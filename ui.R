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
require(dplyr)

# Get data on the teams
load("~/teams.RData")
load("~/player_stats_selected.RData")
teams <- as.vector(teams$Team.Names)

# Setting up the shiny app
ui <- dashboardPage(
  # Title
  dashboardHeader(title = "MLB Trades"),
  
  # Side Panel - We have two tabs, one for predicting trade likelihood and one to visualize trades
  dashboardSidebar(
    sidebarMenu(
      menuItem("Predict Trade", tabName="predict", icon = icon("magic", lib = "font-awesome")),
      menuItem("Trades Map", tabName = "trademap", icon = icon("map-marker", lib = "font-awesome")),
      menuItem("Single Variable Trend", tabName = "trends", icon = icon("line-chart", lib = "font-awesome"))
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
            title = "Batter Input Statistics", status = "primary", solidHeader = TRUE, width = 12, collapsible = TRUE,
            column(
              width = 2,
              numericInput("age", "Age:", value = 25),
              numericInput("3bppa", "Triples per plate appearance:", value = .003)
            ),
            column(
              width = 2,
              numericInput("ba", "Batting Average:", value = 0.285),
              numericInput("hrppa", "Home runs per plate appearance:", value = 0.03)
            ),
            column(
              width = 2,
              numericInput("obp", "On Base Percentage:", value = 0.35),
              numericInput("sbppa", "Stolen bases per plate appearance:", value = 0.002)
            ),
            column(
              width = 2,
              numericInput("rppa", "Runs per plate appearance:", value = 0.1),
              numericInput("soppa", "Strike outs per plate appearance:", value = 0.2)
            ),
            column(
              width = 2,
              numericInput("rbippa", "RBIs per plate appearance:", value = 0.13)
            ),
            column(
              width = 2,
              numericInput("2bppa", "Doubles per plate appearance:", value = 0.05)
            )
          )
        ),
        fluidRow(
          box(
            title = "Pitcher input statistics", status = "primary", solidHeader = TRUE, width = 12, collapsible = TRUE,
            column(
              width = 2,
              numericInput("age_p", "Age:",value = 18),
              numericInput("s9", "Strike outs per 9", value = 7)
            ),
            column(
              width = 2,
              numericInput("wl", "W-L%:", value = 0.8),
              numericInput("fip", "FIP:", value = 3)
            ),
            column(
              width = 2,
              numericInput("era", 'ERA:', value = 3.5),
              numericInput("whip", "WHIP:", value = 2.2)
            ),
            column(
              width = 2,
              numericInput("shpg", "Shutouts per game:", value = 0)
            ),
            column(
              width = 2,
              numericInput("hr9", "Home runs per 9:", value = 3)
            ),
            column(
              width = 2,
              numericInput("svpg", "Saves per game:", value = 0.5)
            )
          )
        ),
        fluidRow(
          valueBox(
            subtitle = "Batter prediction", color = "orange", width = 6, 
            textOutput("pred_b")
          ),
          valueBox(
            subtitle = "Pitcher prediction", color = "orange", width = 6, 
            textOutput("pred_p")
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
            selectInput("team", "Select a team:", choices = teams, multiple = TRUE, selected = "Los Angeles Dodgers")
          )
        ),
        
        fluidRow(
          box(
            title = "Map", status = "warning", solidHeader = FALSE,  width = 12, height=800, collapsible = TRUE,
            plotOutput("map", height=600)
          )
        ),
        fluidRow(
          box(
            title = "Data", status = "warning", solidHeader = TRUE, width = 12, collapsible = TRUE,
            dataTableOutput("table")
          )
        )
      ),
      # Single variable trends TAB-------------------------------------------------------------------------
      # Select a variable and see it's effect on players being traded
      #----------------------------------------------------------------------------------------------------
      tabItem(tabName="trends",
        fluidRow(
          box(
            title = "Batter variable", status = "primary", solidHeader = TRUE, width = 12, collapsible = TRUE,
            selectInput("var_b", "Select a batter statistic:", choices = colnames(players.hitters.stats %>% select(-c(player, Year))))
          )
        ),
        fluidRow(
          box(
            title = "Batter variable vs Traded", status = "warning", solidHeader = FALSE, width = 12, collapsible = TRUE,
            plotOutput("plot_b")
          )
        ),
        fluidRow(
          box(
            title = "Pitcher variable", status = "primary", solidHeader = TRUE, width = 12, collapsible = TRUE,
            selectInput("var_p", "Select a pitcher statistic:", choices = colnames(players.pitchers.stats %>% select(-c(player, Year))))
          )
        ),
        fluidRow(
          box(
            title = "Pitcher variable vs Traded", status = "warning", solidHeader = FALSE, width = 12, collapsible = TRUE,
            plotOutput("plot_p")
          )
        )
      )
    )
  )
)