get_goal_weekly <- function(graph_data) {

  weekly_summary <- graph_data %>%
    mutate(week = week(date)) %>%
    mutate(total_clicks = goal3Completions + goal5Completions) %>%
    group_by(week) %>%
    summarise("G3_Glasgow" = sum(goal3Completions), 
              "G5_Edinburgh" = sum(goal5Completions), 
              "total" = sum(total_clicks),
              "total_sessions" = sum(sessions))

  goal_weekly <- gather(weekly_summary, 
                        goal, 
                        num_clicks, 
                        "G3_Glasgow":"total")

  ggplot(goal_weekly) +
    aes(x = week, y = num_clicks, colour = goal) +
    geom_line() +
    geom_hline(aes(yintercept = 50),
               colour = "blue3",
               size = 0.6)  +
    scale_colour_manual(values = c("#6baed6", "#3182bd", "#08519c")) +
    labs(
      title = "Weekly Event Booking",
      y = "Number of Clicks\n",
      x = "\nWeek number"
    ) +
    coord_cartesian(ylim = c(0, 60)) +
    my_theme()
}