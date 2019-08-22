library(shiny)
library(leaflet)
library(ggplot2)
library(shinythemes)
library(dplyr)
library(lubridate)
library(stringr)
library(tidyverse)

source("get_google_analytics_details.R")
source("create_plots.R")
source("goal_functions/step1_day_data.R")
source("goal_functions/step1_weekly.R")
source("goal_functions/step1.R")
source("goal_functions/map.R")

jscode <- '$(document).on("shiny:connected", function(e) {
        var jsHeight = window.innerHeight;
        Shiny.onInputChange("GetScreenHeight",jsHeight);
});'

my_theme <- function(){
  theme_minimal() +
    theme(
      title = element_text(face = "bold", size = 12), 
      axis.title = element_text(face = "bold", size = 10), 
      panel.grid.major = element_line(colour = "grey82")
    )
}

source("plots_jb.R")
