# Returns the number of sessions in the chosen date range.
get_number_sessions <- function(start_date, end_date) {
        google_analytics(google_analytics_id,
                date_range = c(as.character(start_date),
                        as.character(end_date)
                ),
                metrics = c("sessions")
        )
}

# Returns the number of goal conversions in the chosen date range.
get_number_conversions <- function(start_date, end_date) {
        google_analytics(google_analytics_id,
                date_range = c(as.character(start_date),
                        as.character(end_date)
                ),
                metrics = c("goal3completions", "goal5completions")
        )
}

# Pulls the latitude and longitude of all sessions on the website within the
# defined data range then plots them on leaflet map.

create_map <- function(start_date, end_date) {
        
        # Create a dataset from google analytics.
        Cities <- google_analytics(google_analytics_id,
                date_range = c(as.character(start_date),
                        as.character(end_date)
                ),
                metrics = c("sessions"),
                dimensions = c("city","latitude","longitude"),
                order =  order_type("sessions","DESCENDING", "VALUE")
        )
        
        # Repeat each row for the number of times in the sessions variable.
        # This is so when leaflet creates the groupings on the map, the
        # numbers that appear correspond with the number of sessions rather than
        # the number of rows in the dataset.
        Cities_expanded <- Cities[rep(row.names(Cities), Cities$sessions), ]
        
        # Create leaflet
        leaflet(Cities_expanded) %>%
                addTiles() %>%
                addMarkers(clusterOptions = markerClusterOptions(),
                        lat = as.numeric(Cities_expanded$latitude),
                        lng = as.numeric(Cities_expanded$longitude),
                        popup = Cities_expanded$city
                )
}

# Pulls a list of pages that have the most views within the defined date range
# in descending order from googe analytics, and then plots the top 20 as a
# flipped bar chart.
create_plot_most_views <- function(start_date, end_date) {
        
        # Pulls lsit from google analytics
        most_page_view <- google_analytics(google_analytics_id,
                date_range = c(as.character(start_date), as.character(end_date)),
                metrics = c("pageviews"),
                dimensions = c("pagePath"),
                order =  order_type("pageviews","DESCENDING", "VALUE")
        )
        
        # Plots flipped bar chart
        ggplot(most_page_view[c(1:20), ]) +
                aes(x = reorder(pagePath, pageviews),
                    y = pageviews,
                    fill = pageviews
                ) +
                geom_bar(stat = "identity") +
                coord_flip() +
                my_theme() +
                scale_fill_gradient(low = "#deebf7",
                        high = "#08306b",
                        name = "Number of\nPageviews"
                ) +
                labs(
                        title = "Top 20 Most Visted Pages\n",
                        x = "Page URL\n",
                        y = "\nNumber of exits"
                )
}

# Pulls a list of pages that have the most exits within the defined date range
# in descending order from googe analytics, and then plots the top 20 as a
# flipped bar chart.
create_plot_most_exits <- function(start_date, end_date) {
        
        # Pulls list from google analytics
        most_exit_page <- google_analytics(google_analytics_id,
                date_range = c(as.character(start_date), as.character(end_date)),
                metrics = c("exits"),
                dimensions = c("pagePath"),
                filtersExpression = "ga:pagePath!@thank",
                order =  order_type("exits","DESCENDING", "VALUE")
        )
        
        # Plots flipped bar chart
        ggplot(most_exit_page[c(1:20), ]) +
                aes(x = reorder(pagePath, exits), y = exits, fill = exits) +
                geom_bar(stat = "identity") +
                coord_flip()  +
                my_theme() +
                scale_fill_gradient(low = "#deebf7",
                        high = "#08306b",
                        name = "Number of\nExits"
                ) +
                labs(
                        title = "Top 20 Pages by Exit\n",
                        x = "Page URL\n",
                        y = "\nNumber of Views"
                )
}

# Plotting the devices used from all sessions
get_all_sessions <- function(start_date, end_date) {      
        device_data <- google_analytics(google_analytics_id,
                date_range = c(start_date, end_date),
                metrics = c("sessions"),
                dimensions = c("deviceCategory")
        )
        
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
        test_2 <- google_analytics(google_analytics_id,
                date_range = c(start_date, end_date),
                metrics = c("goal3Completions"),
                dimensions = c("deviceCategory")
        )
        
        test_3 <- google_analytics(google_analytics_id,
                date_range = c(start_date, end_date),
                metrics = c( "goal5Completions"),
                dimensions = c("deviceCategory")
        )
        
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