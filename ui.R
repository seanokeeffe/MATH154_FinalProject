# MATH154 - Computational Statistics
# Pomona College
# Professor Hardin
#
# Final Project
# Jozi McKiernan, Sean O'Keeffe, Sam Woodman

#-----------------------------------------------------------------------------------------------------
# UI File for Shiny App
#-----------------------------------------------------------------------------------------------------

# Load required packages
require(shinydashboard)

# Get data on the teams
load("teams.RData")
teams <- as.vector(teams$Team.Names)

# Setting up the shiny app
ui <- dashboardPage(
  # Title
  dashboardHeader(title = "MLB Trades"),
  
  # Side Panel - We have two tabs, one for predicting trade likelihood and one to visualize trades
  dashboardSidebar(
    sidebarMenu(
      menuItem("Predict Trade", tabName="predict", icon = icon("magic", lib = "font-awesome")),
      menuItem("Trades Map", tabName = "trademap", icon = icon("map-marker", lib = "font-awesome"))
    )
  ),
  
  # The Main Panel
  dashboardBody(
    tabItems(
      # Prediction TAB------------------------------------------------------------------------------------
      # Have inputs for all the statistics and output a prediction
      #---------------------------------------------------------------------------------------------------
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
      # Select all the teams you want to see and maps all those trades
      #---------------------------------------------------------------------------------------------------
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
        ),
        fluidRow(
          box(
            title = "Data", status = "primary", solidHeader = TRUE, width = 12, collapsible = TRUE,
            dataTableOutput("table")
          )
        )
      )
    )
  )
)