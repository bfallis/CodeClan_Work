top1 <- google_analytics(google_analytics_id,
        date_range = c("2019-01-01", "2019-10-08"),
        metrics = c("sessions"),
        dimensions = c("date")
)

write_csv(top1, "user_functions/top_1.csv")

# ==============================================================================

top2 <- google_analytics(google_analytics_id,
        date_range = c("2019-01-01", "2019-10-08"),
        metrics = c("goal3Completions", "goal5Completions"),
        dimensions = c("date")
)

write_csv(top2, "user_functions/top_2.csv")

# ==============================================================================

tab1a1 <- google_analytics(google_analytics_id, 
        date_range = c("2019-01-01", "2019-10-08"), 
        metrics = c("goal3Completions", "goal5Completions", "sessions"), 
        dimensions = c("date")
)

write_csv(tab1a1, "user_functions/tab_1a_1.csv")

# ==============================================================================

tab1a2 <- google_analytics(google_analytics_id, 
        date_range = c("2019-01-01", "2019-10-08"), 
        metrics = c("goal3Completions", "goal5Completions"), 
        dimensions = c("date", "city", "latitude", "longitude"), 
        filtersExpression = "ga:goal3Completions!=0,ga:goal5Completions!=0"
)

write_csv(tab1a2, "user_functions/tab_1a_2.csv")

# ==============================================================================

tab1b1 <- google_analytics(google_analytics_id,
        date_range = c("2019-01-01", "2019-10-08"),
        metrics = c("sessions"),
        dimensions = c("date", "deviceCategory")
)

write_csv(tab1b1, "user_functions/tab_1b_1.csv")

# ==============================================================================

tab1b2 <- google_analytics(google_analytics_id,
        date_range = c("2019-01-01", "2019-10-08"),
        metrics = c("goal3Completions"),
        dimensions = c("date", "deviceCategory")
)

write_csv(tab1b2, "user_functions/tab_1b_2.csv")

# ==============================================================================

tab1b3 <- google_analytics(google_analytics_id,
        date_range = c("2019-01-01", "2019-10-08"),
        metrics = c( "goal5Completions"),
        dimensions = c("date", "deviceCategory")
)

write_csv(tab1b3, "user_functions/tab_1b_3.csv")

# ==============================================================================

tab2a1 <- google_analytics(google_analytics_id, 
        date_range = c("2019-01-01", "2019-10-08"), 
        metrics = c("sessions", "bounceRate", "organicSearches", 
                "goal5ConversionRate", "goal3ConversionRate"
        ), 
        dimensions = c("date", "channelGrouping"),
        max = -1
)

write_csv(tab2a1, "user_functions/tab_2a_1.csv")

# ==============================================================================

tab2a2 <- google_analytics(google_analytics_id,
        date_range = c("2019-01-01", "2019-10-08"),
        metrics = c("sessions", "bounceRate", "organicSearches",
                "goal5ConversionRate", "goal3ConversionRate"
        ),
        dimensions = c("date", "socialNetwork"),
        max = -1
)

write_csv(tab2a2, "user_functions/tab_2a_2.csv")

# ==============================================================================

tab3 <- google_analytics(google_analytics_id,
        date_range = c("2019-01-01", "2019-10-08"),
        metrics = c("sessions"),
        dimensions = c("date", "city","latitude","longitude"),
        order =  order_type("sessions","DESCENDING", "VALUE"),
        max = -1
)

write_csv(tab3, "user_functions/tab_3.csv")

# ==============================================================================

tab4a <- google_analytics(google_analytics_id,
        date_range = c("2019-01-01", "2019-10-08"),
        metrics = c("pageviews"),
        dimensions = c("date", "pagePath"),
        order =  order_type("pageviews","DESCENDING", "VALUE"),
        max = -1
)


write_csv(tab4a, "user_functions/tab_4a.csv")

# ==============================================================================

tab4b <- google_analytics(google_analytics_id,
                 date_range = c("2019-01-01", "2019-10-08"),
                 metrics = c("exits"),
                 dimensions = c("date", "pagePath"),
                 filtersExpression = "ga:pagePath!@thank",
                 order =  order_type("exits","DESCENDING", "VALUE"),
                 max = -1
)

write_csv(tab4b, "user_functions/tab_4b.csv")
