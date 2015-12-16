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
require(ggmap)

# load in data on trades and teams
load("~/allData.RData")
load("~/trades.RData")
load("~/player_stats_selected.RData")

# Train our predictor
source("~/logistic_regression.R", local=TRUE, echo=FALSE)

# Base map layer of the US
usa <- get_map(location='USA', zoom=4)

server <- function(input, output) {
  
  # Reactive Functions------------------------------------------------------------------
  predictBatter <- reactive({ function() {
    new_batter <- data.frame(input$age, input$ba, input$obp, input$rppa, input$`2bppa`, input$`3bppa`, input$hrppa, input$rbippa, input$sbppa, input$soppa)
    colnames(new_batter) <- c('Age', 'BA', 'OBP', 'R/PA', '2B/PA', '3B/PA', 'HR/PA', 'RBI/PA', 'SB/PA', 'SO/PA')
    print(new_batter)
    if (predict(glm.fit.bat, newdata = new_batter, type = "response")>.4) {
      "YES"
    } else {
      "NO"
    }
  }})
  
  predictPitcher <- reactive({ function() {
    new_pitcher <- data.frame(input$age_p, input$wl, input$era, input$shpg, input$svpg, input$fip, input$whip, input$`hr9`, input$`s9`)
    colnames(new_pitcher) <- c('Age', 'W-L%', 'ERA', 'SHO/G', 'SV/G', 'FIP', 'WHIP', 'HR9', 'SO9')
    if (predict(glm.fit.pitch, newdata = new_pitcher, type = "response")>.5) {
      "YES"
    } else {
      "NO"
    }
  }})
  
  plotMap <- reactive({ function() {
    tradeMap <- ggmap(usa)
    # For each team that is selected, add a line segment for all the trades
    for (team in input$team) {
      temp <- all_data %>% filter(NewTeam == team)
      temp_color <- as.character(temp$color[1])
      tradeMap <- tradeMap + geom_segment(aes(x=lon_o, y=lat_o, xend=lon_n, yend=lat_n), data=temp, color=temp_color)
    }
    remove(temp, temp_color, team)
    tradeMap
  }})
  
  getBatterVarPlot <- reactive({ function() {
    temp_df <- data.frame(traded = players.hitters.stats$traded, stat = players.hitters.stats[[input$var_b]])
    ggplot(data = temp_df) + geom_jitter(aes(x=stat, y=traded, color=traded))
  }})
  
  getPitcherVarPlot <- reactive({ function() {
    temp_df <- data.frame(traded = players.pitchers.stats$traded, stat = players.pitchers.stats[[input$var_p]])
    ggplot(data = temp_df) + geom_jitter(aes(x=stat, y=traded, color=traded))
  }})
  #-------------------------------------------------------------------------------------
  
  output$pred_b <- renderText({
    predictBatter()()
  })
  
  output$pred_p <- renderText({
    predictPitcher()()
  })
  
  # Output for mapping the trades
  output$map <- renderPlot({
    plotMap()()
  })
  
  # Output of the data that makes the map
  output$table <- renderDataTable(
    all_data %>% select(-c(MatchKey, lat_n, lon_n, lat_o, lon_o, color)) %>%
      filter(NewTeam %in% input$team)
  )
  
  # Output of the batter variable vs traded plot
  output$plot_b <- renderPlot({
    getBatterVarPlot()()
  })
  
  # Output of the pitcher variable vs traded plot
  output$plot_p <- renderPlot({
    getPitcherVarPlot()()
  })
}