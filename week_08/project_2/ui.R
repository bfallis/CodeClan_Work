shinyUI(fluidPage(
        
        # Adds in the random bit of javascript that somehow makes the map tab
        # size dynamically change with the sie of the window.
        tags$script(jscode),
        
        # Add theme
        theme = shinytheme("cerulean"),
        
        # Title
        titlePanel(tags$h2("CodeClan Website Performance")),
        
        # Creates heading row with date range picker and total sessions and
        # conversions.
        fluidRow(
                column(4,
                        dateRangeInput('date_range',
                                label = 'Pick a date range',
                                start = Sys.Date() - 1,
                                end = Sys.Date()
                        )
                ),
                column(4,
                        span(tags$h5(textOutput("website_visitors")),
                                align = "center"
                        ),
                        span(textOutput("website_visitors_number"),
                                style = "color:red", align = "center"
                        )
                ),
                column(4,
                        span(tags$h5(textOutput("conversions")),
                                align = "center"
                        ),
                        span(textOutput("conversions_number"),
                                style = "color:red", align = "center"
                        )
                )
        ),
        
        navlistPanel(
                "Choose a visualisation:",
                
                tabPanel("Event Goal Overview",
                        fluidRow(
                                column(8,
                                        radioButtons("time_range",
                                                "Display Type",
                                                choices = c("Monthly", "Weekly", "Daily"), 
                                                inline = TRUE
                                        ), 
                                        plotOutput("goal_plot")
                                ),
                           
                                column(4, leafletOutput("map_goal"))
                        ), 
                        fluidRow(
                                column(6, 
                                        plotOutput("device_plot")
                                ), 
                                column(6, 
                                        plotOutput("all_sessions")
                                )
                        )
                ),
                tabPanel("Session Sources\n and Conversion by City",
                        fluidRow(
                                plotOutput("session_channel"),
                                plotOutput("session_social"),
                                plotOutput("channel_conversion_comparison"),
                                plotOutput("social_conversion_comparison")
                        )
                ),
                tabPanel("Map of Sessions",
                         uiOutput("map_1")
                ),
                tabPanel("Top 20 Sessions and Exits",
                         plotOutput("plot_5a"),
                         plotOutput("plot_5b")
                ),
                tabPanel(tags$a("CodeClan's Website",
                                href = "https://codeclan.com/")
                )
        )
))
