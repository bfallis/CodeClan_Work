shinyServer(function(input, output) {
        # Get the number of days between the start and end dates
        span <- reactive({
                as.POSIXlt(input$date_range[2]) -
                as.POSIXlt(input$date_range[1])
        })
        
        # Create the text at the top showing the number of visitors to the
        # website in the date range specified.
        output$website_visitors <- renderText({
                validate(
                        need(input$date_range[2] >= input$date_range[1],
                        "End date is earlier than start date")
                )
                
                paste("Website visitors in the last ",
                        span(),
                        " days: "
                )
        })
        output$website_visitors_number <- renderText({
                paste(get_number_sessions(input$date_range[1],
                        input$date_range[2])
                )
        })
        
        # Create the text at the top showing the number of conversions to the
        # website in the date range specified.
        output$conversions <- renderText({
                validate(
                        need(input$date_range[2] >= input$date_range[1],
                        "End date is earlier than start date")
                )
                
                paste("Conversions in the last ",
                      span(),
                      " days: "
                )
        })
        output$conversions_number <- renderText({
                rowSums(
                        get_number_conversions(input$date_range[1],
                                input$date_range[2]
                        )
                )
        })
        
        # Create the most viewed pages output.
        output$plot_5a <- renderPlot({
                create_plot_most_views(input$date_range[1], input$date_range[2])
        })
        
        # Create the most exited pages output.
        output$plot_5b <- renderPlot({
                create_plot_most_exits(input$date_range[1], input$date_range[2])
        })
        
        # Creates the map. In order to have the map render over the full page
        # instead of the top half we have to use some javascript to dynamically
        # get the height of the window. We then render a UI output to the UI of
        # that size and the only element in that UI output is the leaflet map.
        output$map_1 <- renderUI({
                leafletOutput("full_map",
                        width = "100%",
                        height = input$GetScreenHeight
                )
        })
        
        output$full_map <- renderLeaflet({
                create_map(input$date_range[1], input$date_range[2])
        })

        #plot of devices used to book events
        output$device_plot = renderPlot({
                get_device_plot(input$date_range[1], input$date_range[2])
        })
        
        # plot of devices used for all sessions
        output$all_sessions = renderPlot({
                get_all_sessions(input$date_range[1], input$date_range[2])
        })
        
        ###########################################
        #####       JB OUTPUTS     ################
        ###########################################
        
        ####create plot for sessions by channel
        output$session_channel <- renderPlot({
                session_channel(input$date_range[1], input$date_range[2])
        })
        
        ###Create plot for Session by Social Network
        output$session_social <- renderPlot({
                session_social(input$date_range[1], input$date_range[2])
        })

        # ###create plot for conversion comparison by social network
        output$social_conversion_comparison <- renderPlot({
                social_conversion_comparison(input$date_range[1], input$date_range[2])
        })
        # 
        # ###create plot for conversion comparison by channel
        output$channel_conversion_comparison <- renderPlot({
                channel_conversion_comparison(input$date_range[1], input$date_range[2])
        })

        output$goal_plot <- renderPlot({
            
            # set the date to range for plots
            start_month = seq(floor_date(today(), "month"), 
                              length = 3, by = "-1 months")
            date_end_month = start_month - 1
            
            start_date_clicks <- NULL
            
            if(input$date_range[1] < start_month[3]) {
                start_date_clicks <- input$date_range[1]
            } else {
                start_date_clicks <- start_month[3]
            }
            
            # Getting the data for the number of clicks and number of sessions
            goals_and_session <- reactive({
                google_analytics(
                    google_analytics_id, 
                    date_range = c(start_date_clicks, today()), 
                    metrics = c("goal3Completions", 
                                "goal5Completions", 
                                "sessions"), 
                    dimensions = c("date")
                )
            })
            
            # Creating the plots
            if(input$time_range == "Monthly"){
                get_goal_monthly(goals_and_session())
            } else if (input$time_range == "Weekly") {
                get_goal_weekly(goals_and_session())
            } else if (input$time_range == "Daily") {
                get_goal_daily(goals_and_session())
            }
        })
        
        output$map_goal <- renderLeaflet({
            get_goal_map(input$date_range[1], input$date_range[2])
        })
})