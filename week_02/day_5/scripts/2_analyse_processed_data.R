#Read in processed data
employees_with_teams_feedbacks <-
        read.csv("./data/processed/employees_with_teams_feedbacks.csv")

#Which of our teams has the angriest employee?
angriest <- employees_with_teams_feedbacks[employees_with_teams_feedbacks$anger 
        == max(employees_with_teams_feedbacks$anger), ]
angriest

#Can you tell us the emotional state of each of our teams for which we have
#feedbacks?
aggregated_by_team <- employees_with_teams_feedbacks[ , c("anger", "fear",
        "joy", "sadness", "surprise")]

emotional_state <- aggregate(aggregated_by_team,
        by = list(employees_with_teams_feedbacks$team_name), FUN = mean)
emotional_state

#Which of our teams is the happiest overall?
aggregated_by_team <- employees_with_teams_feedbacks[ , "joy"]

mean_team_joy <- aggregate(aggregated_by_team,
        by = list(employees_with_teams_feedbacks$team_name), FUN = mean)

names(mean_team_joy) <- c("team_name", "joy")

happiest <- mean_team_joy[mean_team_joy$joy == max(mean_team_joy$joy), ]
happiest

rm(list = c("aggregated_by_team", "mean_team_joy",
        "employees_with_teams_feedbacks"))
