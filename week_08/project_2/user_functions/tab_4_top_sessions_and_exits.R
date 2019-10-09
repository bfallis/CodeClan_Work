# ==============================================================================
#
# Tab 4 - Top 20 Sessions and Exits
#
# ==============================================================================

# Pulls a list of pages that have the most views within the defined date range
# in descending order from googe analytics, and then plots the top 20 as a
# flipped bar chart.
create_plot_most_views <- function(start_date, end_date) {
        
        # Pulls lsit from google analytics
        #most_page_view <- google_analytics(google_analytics_id,
        #        date_range = c(as.character(start_date), as.character(end_date)),
        #        metrics = c("pageviews"),
        #        dimensions = c("pagePath"),
        #        order =  order_type("pageviews","DESCENDING", "VALUE")
        #)
        
        most_page_view <- read_csv("user_functions/tab_4a.csv")
        
        most_page_view <- most_page_view %>%
                filter(date >= start_date & date <= end_date) %>%
                group_by(pagePath) %>%
                summarise(pageviews = sum(pageviews)) %>%
                arrange(desc(pageviews))
        
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
        #most_exit_page <- google_analytics(google_analytics_id,
        #        date_range = c(as.character(start_date), as.character(end_date)),
        #        metrics = c("exits"),
        #        dimensions = c("pagePath"),
        #        filtersExpression = "ga:pagePath!@thank",
        #        order =  order_type("exits","DESCENDING", "VALUE")
        #)
        
        most_exit_page <- read_csv("user_functions/tab_4b.csv")
        
        most_exit_page <- most_exit_page %>%
                filter(date >= start_date & date <= end_date) %>%
                group_by(pagePath) %>%
                summarise(exits = sum(exits)) %>%
                arrange(desc(exits))
        
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