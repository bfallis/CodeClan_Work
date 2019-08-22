# Load required libraries.
library(dplyr)
library(ggplot2)
library(leaflet)
library(lubridate)
library(shiny)
library(shinythemes)
library(stringr)
library(tidyverse)

#Source in files containing functions.
source("user_functions/plot_theme.R")
source("user_functions/get_google_analytics_details.R")
source("user_functions/top_of_page.R")
source("user_functions/tab_1a_sessions_vs_conversions_and_map.R")
source("user_functions/tab_1b_sessions_and_conversions_by_device_type.R")
source("user_functions/tab_2_sessions_and_conversions_by_city.R")
source("user_functions/tab_3_map_of_sessions.R")
source("user_functions/tab_4_top_sessions_and_exits.R")

# Random javascript code that allows dynamic resizing of the map.
jscode <- '$(document).on("shiny:connected", function(e) {
        var jsHeight = window.innerHeight;
        Shiny.onInputChange("GetScreenHeight",jsHeight);
});'