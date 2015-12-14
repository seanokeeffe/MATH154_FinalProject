require(shiny)
require(dplyr)

teams <- read.csv("team_names.csv")
teams <- as.vector(teams$Team.Names)

server <- function(input, output) {
  
    trades <- read.csv('10-15Trades.csv', sep = ',')
    usa <- get_map(location='USA', zoom=4)
    
    output$map <- renderPlot(
      {
        plot <- ggmap(usa)
        for (team in input$team) {
          temp <- trades %>% filter(NewTeam == team)
          temp_color <- as.character(temp$color[1])
          plot <- plot + geom_segment(aes(x=lon_o, y=lat_o, xend=lon_n, yend=lat_n), data=temp, color=temp_color)
        }
        plot
      }
    )
  }
