# MATH 154 - Computational Statistics
# Pomona College
# Professor Hardin

#------------------------------------------------------------------------------------
# Prediction of Trades and Data Visualization of MLB Data
# 
#    Contributors: Jozi McKiernan
#                  Sean O'Keeffe
#                  Sam Woodman
#------------------------------------------------------------------------------------

# Get data on MLB teams. 'teams' will consist of every MLB team, their 
# location(city and lat lon), and their main color. This data is used to prepare 
# the trade data and for the shiny app.
source('get_team_data.R', local=TRUE, echo=FALSE)

# Get data on trades that happened between 2010 and 2015.
# 'trades' consists of all the data, which has the team the player was traded from, 
# the team the player was traded to, the players name, and the date of the trade
# Note: Sometimes the url connection used to get the trade data fails. We haven't
# found a solution to this problem but if you rerun this file, it will eventually
# collect all the data.
source('get_trade_data.R', local=TRUE, echo=FALSE)
