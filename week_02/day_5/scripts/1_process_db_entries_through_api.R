library(keyring)
library(RPostgreSQL)
library(httr)
library(purrr)

source("./scripts/api_fetcher.R")
source("./scripts/response_unpacker.R")

#Get database username and password
keyring_unlock(keyring = "local")
username <- key_get("postgresql_username", keyring = "local")
password <- key_get("postgresql_password", keyring = "local")
keyring_lock(keyring = "local")

#Get indico api key
keyring_unlock(keyring = "remote")
indico_api_key <- key_get("indico_api_key", keyring = "remote")
keyring_lock(keyring = "remote")

#Create local database connection
db_connection <- dbConnect(drv = PostgreSQL(max.con = 1), user = username,
        password = password, dbname = "acme_employees", host = "localhost")
rm(list = c("password", "username"))

#Bring back data from postgres database
employees_with_teams_feedbacks <- dbGetQuery(db_connection,
        "SELECT e.first_name
                , e.last_name
                , e.email
                , t.name AS team_name
                , f.message
                , f.date AS message_date
         FROM feedbacks AS f
                JOIN employees AS e ON f.employee_id = e.id
                JOIN teams AS T on e.team_id = t.id
         WHERE f.date = (SELECT MAX(date) 
                        FROM feedbacks
                        WHERE feedbacks.employee_id = f.employee_id)
         ORDER BY t.name, e.last_name"
)

#Close database connection
dbDisconnect(db_connection)

#Set indico username
url <- "https://apiv2.indico.io/emotion"

#Create data frame
message_emotions <- data.frame(anger = 0, fear = 0, joy = 0, sadness = 0,
        surprise = 0)

#For each row brought back from postgresql, pass the message through the
#indico emotion checker and build another data frame
for (record in 1:nrow(employees_with_teams_feedbacks)) {
        result <- api_fetcher(url, indico_api_key,
                employees_with_teams_feedbacks[record, "message"])
        
        result_vector <- response_unpacker(result)
        
        message_emotions <- rbind(message_emotions, result_vector)
}

#Remove the first row of the data frame which was all 0. Done to preserve the
#naming of the columns
message_emotions <- message_emotions[-1, ]

#Combine the 2 data frames
employees_with_teams_feedbacks <- cbind(employees_with_teams_feedbacks,
        message_emotions)

#Write result to csv
write.csv(employees_with_teams_feedbacks,
        "data/processed/employees_with_teams_feedbacks.csv")
