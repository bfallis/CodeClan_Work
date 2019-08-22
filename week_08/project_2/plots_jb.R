library(googleAnalyticsR)
library(tidyverse)
library(dplyr)
library(ggplot2)



#Authenticate your account
#ga_auth()

#Get a list of accounts you have access to
#account_list <- ga_account_list()

#ViewID is the way to access the account you want
#account_list$viewId

#my_ga_id <- 102407343

#start_date <- "2019-01-01"
#end_date <- "2019-08-19"


#Call the API to access the data you require

##Pulling the data for the channel groups
get_channel_group_df <- function(start_date, end_date) {

  channel_group_df <- google_analytics(google_analytics_id, 
     date_range = c(as.character(start_date), as.character(end_date)), 
     metrics = c("sessions", "bounceRate", "organicSearches", "goal5ConversionRate", "goal3ConversionRate"), 
     dimensions = "channelGrouping")
     print("got this far")
     #order =  order_type("sessions","DESCENDING", "VALUE")
     
  return(channel_group_df)
}
##Pulling the data for the Social networks

get_social_group_df <- function(start_date, end_date) {
social_group_df <- google_analytics(google_analytics_id,
                  date_range = c(start_date, end_date),
                  metrics = c("sessions", "bounceRate", "organicSearches", "goal5ConversionRate", "goal3ConversionRate"),
                  dimensions = "socialNetwork")

##removing the row which is (not set)
      social_group_df<- dplyr::filter(social_group_df, socialNetwork != "(not set)")
      #social_group_df<- dplyr::filter(social_group_df, sessions != 0)
      return(social_group_df)
}


#### PLOT FUNCTION: Number of Sessions by Channel
##Call using:
##session_channel(channel_group_df)
session_channel <- function(start_date, end_date){
  channel_group_df <- get_channel_group_df(as.character(start_date), as.character(end_date))
  
 ggplot(channel_group_df) +
   aes(x = channel_group_df$channelGrouping, y = channel_group_df$sessions, fill = channelGrouping) +
   geom_col() +
   labs(
     x = "\nChannel",
     y = "Sessions\n",
     title = "Sessions by Channel\n",
     fill = "Channel"
   ) +
   my_theme() +
   theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
   #scale_fill_manual(values = c("#9ecae1", "#6baed6", "#2171b5", "#08519c", "#08306b"))
   scale_fill_brewer(palette = "Blues")
}

####
###PLOT FUNCTION: nummber of sessions by Social Network
###Call Using:
###session_social(social_group_df)

session_social <- function(start_date, end_date){
  social_group_df <- get_social_group_df(start_date, end_date)
  ggplot(social_group_df) +
    aes(x = social_group_df$socialNetwork, y = social_group_df$sessions, fill = socialNetwork) +
    geom_col() +
    labs(
      x = "\nSocial Network",
      y = "Sessions\n",
      title = "Breakdown of Social Channel by Social Network\n",
      fill = "Social Network"
    ) + my_theme() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    #scale_fill_manual(values = c("#9ecae1", "#6baed6", "#2171b5", "#08519c", "#08306b"))
    scale_fill_brewer(palette = "Blues")
  
}

####

###Create a new data.frame containing only the information I need to use 
filter_social <- function(social_group_df){
  social_group_df2 <- social_group_df %>% select(socialNetwork, goal3ConversionRate, goal5ConversionRate)

  ###gather the goal3ConversionRate and goal5ConversionRate data into a new column to use fill + location
  gathered_social<-gather(social_group_df2, key="location", value= conversion, -socialNetwork)

  return(gathered_social)
}



####
####PLOT FUNCTION: comparison of goal conversion for Edinburgh and Glasgow by Social Network
###Call Using: social_conversion_comparison(gathered_social)
social_conversion_comparison <- function(start_date, end_date){
  social_group_df <- get_social_group_df(start_date, end_date)
  gathered_social <- filter_social(social_group_df)
  ggplot(gathered_social, aes(socialNetwork, conversion, fill=location)) +
    geom_bar(stat = "identity",position="dodge") +
    labs(
      x = "\nSocial Network",
      y = "Conversion (%)\n",
      title = "Info Session Conversion Comparison by Social Network\n"
    )+
    #scale_fill_discrete(name = "Location", labels = c("Glasgow", "Edinburgh")) +
    my_theme() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_fill_manual(name = "Location", values = c("#6baed6", "#08306b"), labels = c("Glasgow", "Edinburgh"))
}

###
filter_channel <- function(channel_group_df){
###create new data.frame which contains only the columns I need to work with
  channel_group_df2 <- channel_group_df %>%
    select(channelGrouping, goal3ConversionRate, goal5ConversionRate)

  ###bather the goal3ConversionRate and goal5ConversionRate data into a new column to use fill + location
  gathered_channel<- gather(channel_group_df2, key="location", value= conversion, -channelGrouping)

  return(gathered_channel)

}

####
###PLOT FUNCTION: comparison of goal conversion for Edinburgh and Glasgow by Channel
###CALL USING: channel_conversion_comparison(gathered_channel)
channel_conversion_comparison <- function(start_date, end_date){
  channel_group_df <- get_channel_group_df(start_date, end_date)
  gathered_channel <- filter_channel(channel_group_df)
  ggplot(gathered_channel, aes(channelGrouping, conversion, fill=location)) +
    geom_bar(stat = "identity",position="dodge") +
    labs(
      x = "\nChannel",
      y = "Conversion (%)\n",
      title = "Info Session Conversion Comparison by Channel\n"
    ) +
    #scale_fill_discrete(name = "Location", labels = c("Glasgow", "Edinburgh"))+
    my_theme() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_fill_manual(name = "Location", values = c("#6baed6", "#08306b"), labels = c("Glasgow", "Edinburgh"))
}
# 
# channel_conversion_comparison(gathered_channel)
