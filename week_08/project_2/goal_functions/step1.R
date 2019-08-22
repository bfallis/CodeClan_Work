get_goal_monthly <- function (graph_data){
  
  # plotting for the monthly targets
  # Preparing the data per month
  goal_summary <- graph_data %>%
    mutate(month = month(date, label = TRUE, abbr = TRUE)) %>%
    mutate(total_clicks = goal3Completions + goal5Completions) %>%
    group_by(month) %>%
    summarise("G3_Glasgow" = sum(goal3Completions), 
              "G5_Edinburgh" = sum(goal5Completions), 
              "total" = sum(total_clicks),
              "total_sessions" = sum(sessions))

    goal_monthly <- gather(goal_summary, 
                           goal, 
                           num_clicks, 
                           "G3_Glasgow":"total")

    ggplot(goal_monthly) +
      geom_bar(aes(x = month, y = num_clicks, fill = goal), 
               stat = "identity", position = "dodge") +
      geom_hline(aes(yintercept = 200, colour = "blue3"), 
                 size = 0.6)  +
      geom_text(aes(x = month, y = 200, 
                    label = paste("Sessions:\n", total_sessions)), 
                nudge_y = 20, 
                size = 3.1, 
                data = filter(goal_monthly, goal == "G5_Edinburgh")) +
      scale_fill_manual(values = c("#6baed6", "#3182bd", "#08519c")) +
      scale_colour_manual(name = "legend", 
                          values = "blue3", 
                          labels = "target"
      ) +
      labs(
        title = "Monthly Event Booking",
        y = "Number of Clicks\n",
        x = "\nMonth"
      ) +
      coord_cartesian(ylim = c(0, 250)) +
      my_theme() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
}




