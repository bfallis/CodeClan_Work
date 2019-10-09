# ==============================================================================
#
# Top of page
#
# ==============================================================================

# Returns the number of sessions in the chosen date range.
get_number_sessions <- function(start_date, end_date) {
        #google_analytics(google_analytics_id,
        #        date_range = c(as.character(start_date),
        #                as.character(end_date)
        #        ),
        #        metrics = c("sessions")
        #)

        top1 <- read_csv("user_functions/top_1.csv")
        
        top1 <- top1 %>%
                filter(date >= start_date & date <= end_date) %>%
                summarise(sum(sessions))
        
        return(top1)
}

# Returns the number of goal conversions in the chosen date range.
get_number_conversions <- function(start_date, end_date) {
        #google_analytics(google_analytics_id,
        #        date_range = c(as.character(start_date),
        #                as.character(end_date)
        #        ),
        #        metrics = c("goal3completions", "goal5completions")
        #)

        top2 <- read_csv("user_functions/top_2.csv")
        
        top2 <- top2 %>%
                filter(date >= start_date & date <= end_date) %>%
                summarise(goal3Completions = sum(goal3Completions),
                        goal5Completions = sum(goal5Completions)
                )
        
        return(top2)
}
