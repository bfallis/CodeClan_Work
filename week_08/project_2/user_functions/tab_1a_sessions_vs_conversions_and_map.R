# ==============================================================================
#
# Tab 1a - Sessions Vs. Conversions and Map of Conversions
#
# ==============================================================================

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
                                "total_clicks"
                        ),
                        labels = c("G3(Glasgow)","G5(Edinburgh)", "total"), 
                        values = c("#6baed6", "#3182bd", "#08519c")
                ) +
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

get_goal_weekly <- function(graph_data) {
        weekly_summary <- graph_data %>%
                mutate(week = week(date)) %>%
                mutate(total_clicks = goal3Completions + goal5Completions) %>%
                group_by(week) %>%
                summarise("G3_Glasgow" = sum(goal3Completions), 
                        "G5_Edinburgh" = sum(goal5Completions), 
                        "total" = sum(total_clicks),
                        "total_sessions" = sum(sessions)
                )
        
        goal_weekly <- gather(weekly_summary, goal, num_clicks, 
                "G3_Glasgow":"total")
        
        ggplot(goal_weekly) +
                aes(x = week, y = num_clicks, colour = goal) +
                geom_line() +
                geom_hline(aes(yintercept = 50),
                        colour = "blue3",
                        size = 0.6
                )  +
                scale_colour_manual(values = 
                        c("#6baed6", "#3182bd", "#08519c")) +
                labs(
                        title = "Weekly Event Booking",
                        y = "Number of Clicks\n",
                        x = "\nWeek number"
                ) +
                coord_cartesian(ylim = c(0, 60)) +
                my_theme()
}

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
                        "total_sessions" = sum(sessions)
                )
        
        goal_monthly <- gather(goal_summary, goal, num_clicks, 
                "G3_Glasgow":"total"
        )
        
        ggplot(goal_monthly) +
                geom_bar(aes(x = month, y = num_clicks, fill = goal), 
                        stat = "identity", position = "dodge"
                ) +
                geom_hline(aes(yintercept = 200, colour = "blue3"), 
                        size = 0.6
                )  +
                geom_text(aes(x = month, y = 200, label = paste("Sessions:\n",
                                total_sessions)
                        ), 
                        nudge_y = 20, 
                        size = 3.1, 
                        data = filter(goal_monthly, goal == "G5_Edinburgh")
                ) +
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

# Getting the data for the number of clicks and number of sessions
get_goal_map <- function(start_date, end_date) {
        
        # set the date to range for plots
        start_month = seq(floor_date(date("2019-10-08"), "month"), length = 3,
                by = "-1 months"
        )
        
        date_end_month = start_month - 1
        
        if(start_date < start_month[3]) {
                start_date_clicks <- start_date
        } else {
                start_date_clicks <- start_month[3]
        }
        
        # call the api
        #goals_geo <- google_analytics(
        #        google_analytics_id, 
        #        date_range = c(start_date_clicks, today()), 
        #        metrics = c("goal3Completions", 
        #                "goal5Completions"), 
        #        dimensions = c("city", "latitude", "longitude"), 
        #        filtersExpression = 
        #                "ga:goal3Completions!=0,ga:goal5Completions!=0"
        #)
        
        goals_geo <- read_csv("user_functions/tab_1a_2.csv")
        
        goals_geo <- goals_geo %>%
                filter(date >= start_date & date <= end_date) %>%
                group_by(city, latitude, longitude) %>%
                summarise(goal3Completions = sum(goal3Completions),
                        goal5Completions = sum(goal5Completions)
                )
        
        # format the data to create the map
        goals_map <- goals_geo %>%
                mutate(total = goal3Completions + goal5Completions)
        
        goals_map$latitude <- as.numeric(goals_map$latitude)
        goals_map$longitude <- as.numeric(goals_map$longitude)
        colnames(goals_map) <- c("city", "latitude", "longitude", 
                "G3_Glasgow", "G5_Edinburgh", "total"
        )
        
        # create the map
        leaflet(goals_map) %>% 
                addTiles() %>%
                addMarkers(lng = ~longitude, 
                        lat = ~latitude, 
                        clusterOptions = markerClusterOptions(),        
                        popup = paste("City",  goals_map$city, "<br>",
                                "Goal3", goals_map$G3_Glasgow, "<br>",
                                "Goal5", goals_map$G5_Edinburgh
                        )
                ) %>%
                setView(-4.140302, 56.6847, zoom = 5.6) 
} 