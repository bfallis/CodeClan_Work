get_goal_daily <-  function(graph_data) {

  goal_daily <- graph_data %>%
    mutate(total_clicks = goal3Completions + goal5Completions) %>% 
    select(-sessions) %>%
    gather(goal, num_clicks, "goal3Completions":"total_clicks")

  ggplot(goal_daily) +
    aes(x = date, y = num_clicks, colour = goal) +
    geom_line() +
    geom_hline(aes(yintercept = 6.7),
               colour = "blue3",
               size = 0.6)  +
    scale_x_date(date_breaks = "5 days") +
    scale_y_continuous(breaks = seq(0, 12, 2)) +
    scale_colour_manual(name = "legend",
                        breaks = c("goal3Completions", "goal5Completions", 
                                   "total_clicks"),
                        labels = c("G3(Glasgow)","G5(Edinburgh)", 
                                   "total"), 
                        values = c("#6baed6", "#3182bd", "#08519c")) +
    labs(
      title = "Daily event booking",
      y = "Number of Clicks\n",
      x = "\nDate"
    ) +
    coord_cartesian(ylim = c(0, 12)) +
    my_theme() +
    theme(
      panel.grid.minor = element_blank(),
      axis.text.x = element_text(angle = 45, hjust = 1) 
    )
}

  
