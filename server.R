# MATH154 - Computational Statistics
# Pomona College
# Professor Hardin
#
# Final Project
# Jozi McKiernan, Sean O'Keeffe, Sam Woodman

#-----------------------------------------------------------------------------------------------------
# Server File for Shiny App
#-----------------------------------------------------------------------------------------------------

# load required packages
require(shiny)
require(dplyr)

# load in data on trades and teams
load("trades.RData")
load("teams.RData")

# Add to trades data, the location and color of each team
all_data <- trades
for (i in 1:nrow(all_data)) {
  newTeam <- teams %>% filter(Team.Names == as.character(all_data$NewTeam[i]))
  oldTeam <- teams %>% filter(Team.Names == as.character(all_data$OldTeam[i]))
  all_data$lat_n[i] <- newTeam$lat
  all_data$lon_n[i] <- newTeam$lon
  all_data$lat_o[i] <- oldTeam$lat
  all_data$lon_o[i] <- oldTeam$lon
  all_data$color[i] <- as.character(newTeam$Color)
}

# Base map layer of the US
usa <- get_map(location='USA', zoom=4)

server <- function(input, output) {
    # Output for mapping the trades
    output$map <- renderPlot(
      {
        plot <- ggmap(usa)
        # For each team that is selected, add a line segment for all the trades
        for (team in input$team) {
          temp <- all_data %>% filter(NewTeam == team)
          temp_color <- as.character(temp$color[1])
          plot <- plot + geom_segment(aes(x=lon_o, y=lat_o, xend=lon_n, yend=lat_n), data=temp, color=temp_color)
        }
        plot
      }
    )
    
    # Output of the data that makes the map
    output$table <- renderDataTable(
      trades %>% filter(NewTeam %in% input$team) %>% select(-MatchKey)
    )
  }
