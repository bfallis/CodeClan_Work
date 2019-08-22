# ==============================================================================
#
# Tab 3 - Map of sessions
#
# ==============================================================================

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