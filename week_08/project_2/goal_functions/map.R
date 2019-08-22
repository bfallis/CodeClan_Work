# Getting the data for the number of clicks and number of sessions
get_goal_map <- function(start_date, end_date) {

  # set the date to range for plots
  start_month = seq(floor_date(today(), "month"), length = 3, by = "-1 months")
  date_end_month = start_month - 1

  if(start_date < start_month[3]) {
    start_date_clicks <- start_date
  } else {
    start_date_clicks <- start_month[3]
  }

  # call the api
  goals_geo <- google_analytics(
    google_analytics_id, 
    date_range = c(start_date_clicks, today()), 
    metrics = c("goal3Completions", 
              "goal5Completions"), 
    dimensions = c("city", "latitude", "longitude"), 
    filtersExpression = "ga:goal3Completions!=0,ga:goal5Completions!=0"
  )

  # format the data to create the map
  goals_map <- goals_geo %>%
    mutate(total = goal3Completions + goal5Completions)
  
    goals_map$latitude <- as.numeric(goals_map$latitude)
    goals_map$longitude <- as.numeric(goals_map$longitude)
    colnames(goals_map) <- c("city", "latitude", "longitude", 
                         "G3_Glasgow", "G5_Edinburgh", "total")

  # create the map
  leaflet(goals_map) %>% 
    addTiles() %>%
    addMarkers(lng = ~longitude, 
             lat = ~latitude, 
             clusterOptions = markerClusterOptions(),        
             popup = paste("City",  goals_map$city, "<br>",
                           "Goal3", goals_map$G3_Glasgow, "<br>",
                           "Goal5", goals_map$G5_Edinburgh)) %>%
    setView(-4.140302, 56.6847, zoom = 5.6) 

} 
