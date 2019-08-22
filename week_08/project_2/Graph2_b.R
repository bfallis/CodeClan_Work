
test_2 <- google_analytics(google_analytics_id,
                        date_range = c("2019-08-13", "2019-08-19"),
                        metrics = c("goal3Completions"),
                        dimensions = c("deviceCategory")
                        
)

test_3 <- google_analytics(google_analytics_id,
                          date_range = c("2019-08-13", "2019-08-19"),
                          metrics = c( "goal5Completions"),
                          dimensions = c("deviceCategory")
                          
)

library(ggplot2)
library(readr)
library(dplyr)
library(tidyverse)

my_theme <- function(){
  theme_minimal() +
    theme(
      title = element_text(face = "bold", size = 12),
      axis.title = element_text(face = "bold", size = 10),
      panel.grid.major = element_line(colour = "grey82")
    )
}



test_2$goal5Completions <- test_3$goal5Completions
all_test <- test_2 %>%
  gather(goal, num_device, "goal3Completions":"goal5Completions")

ggplot(all_test) +
  geom_bar(aes(x = deviceCategory, y = num_device, fill = goal),
           stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("#6baed6", "#3182bd", "#08519c")) +
  labs(title = "Device used for Edin/Glas event bookings") + 
    my_theme()


  
  
