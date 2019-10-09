# ==============================================================================
#
# Tab 1b - Sessions and Conversions by Device Type
#
# ==============================================================================

# Plotting the devices used from all sessions
get_all_sessions <- function(start_date, end_date) {      
        #device_data <- google_analytics(google_analytics_id,
        #        date_range = c(start_date, end_date),
        #        metrics = c("sessions"),
        #        dimensions = c("deviceCategory")
        #)
        
        device_data <- read_csv("user_functions/tab_1b_1.csv")
        
        device_data <- device_data %>%
                filter(date >= start_date & date <= end_date) %>%
                group_by(deviceCategory) %>%
                summarise(sessions = sum(sessions))
        
        ggplot(device_data) +
                geom_col(aes(x = deviceCategory, 
                        y = sessions, 
                        fill = deviceCategory)
                ) +
                scale_fill_manual(values =  c("#6baed6", "#3182bd", "#08519c"),
                        name = "Device\nCategory"
                ) +
                my_theme() +
                labs(
                        title = "Sessions by Device Used",
                        x = "\nType of Device",
                        y = "Number of sessions\n"
                )
}

# Plotting the devices used to book events
get_device_plot <- function(start_date, end_date) {
        #test_2 <- google_analytics(google_analytics_id,
        #        date_range = c(start_date, end_date),
        #        metrics = c("goal3Completions"),
        #        dimensions = c("deviceCategory")
        #)
        
        test_2 <- read_csv("user_functions/tab_1b_2.csv")
        
        test_2 <- test_2 %>%
                filter(date >= start_date & date <= end_date) %>%
                group_by(deviceCategory) %>%
                summarise(goal3Completions = sum(goal3Completions))
        
        #test_3 <- google_analytics(google_analytics_id,
        #        date_range = c(start_date, end_date),
        #        metrics = c( "goal5Completions"),
        #        dimensions = c("deviceCategory")
        #)
        
        test_3 <- read_csv("user_functions/tab_1b_3.csv")
        
        test_3 <- test_3 %>%
                filter(date >= start_date & date <= end_date) %>%
                group_by(deviceCategory) %>%
                summarise(goal5Completions = sum(goal5Completions))
        
        test_2$goal5Completions <- test_3$goal5Completions
        
        all_test <- test_2 %>%
                gather(goal, num_device, "goal3Completions":"goal5Completions")
        
        ggplot(all_test) +
                geom_bar(aes(x = deviceCategory, y = num_device, fill = goal),
                         stat = "identity", position = "dodge") +
                scale_fill_manual(values = c("#6baed6", "#3182bd", "#08519c"),
                        name = "Goal"
                ) +
                labs(
                        title = "Type of device used to book event", 
                        x = "\nType of Device", 
                        y = "Num. Events Booked\n"
                ) +
                my_theme()
        
}