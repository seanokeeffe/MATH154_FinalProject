library(shinydashboard)

teams <- read.csv("team_names.csv")
teams <- as.vector(teams$Team.Names)

ui <- dashboardPage(
  dashboardHeader(title = "MLB Trades"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Predict Trade", tabName="predict", icon = icon("magic", lib = "font-awesome")),
      menuItem("Trades Map", tabName = "trademap", icon = icon("map-marker", lib = "font-awesome"))
    )
  ),
  dashboardBody(
    tabItems(
      # Prediction TAB------------------------------------------------------------------------------------
      tabItem(tabName="predict",
        fluidRow(
          box(
            title = "Input Statistics", status = "primary", solidHeader = TRUE, width = 12, collapsible = TRUE,
            column(
              width = 6,
              textInput("rbi", "RBI:", value = "")
            ),
            column(
              width = 6,
              textInput("hr", "HR:", value = "")
            )
          )
        )
      ),
      # Trades Map TAB------------------------------------------------------------------------------------
      tabItem(tabName="trademap",
        # Boxes need to be put in a row (or column)
        fluidRow(
          box(
            title = "Select teams:", status = "primary", solidHeader = TRUE,  width = 12, collapsible = TRUE,
            selectInput("team", "Select a team:", choices = teams, multiple = TRUE, selected = "San Diego Padres")
          )
        ),
        
        fluidRow(
          box(
            title = "Map", status = "primary", solidHeader = TRUE,  width = 12, height=800, collapsible = TRUE,
            plotOutput("map", height=600)
          )
        )
      )
    )
  )
)