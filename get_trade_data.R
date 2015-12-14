# MATH154 - Computational Statistics
# Pomona College
# Professor Hardin
#
# Final Project
# Jozi McKiernan, Sean O'Keeffe, Sam Woodman

#-----------------------------------------------------------------------------------------------------
# Data Collection - Getting trade data for MLB
#-----------------------------------------------------------------------------------------------------

# Required packages
require(RCurl)
require(jsonlite)
require(dplyr)

# Used later to get the number of days in a month
numDaysInMonth <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)

# The data frame we eventually fill with trades
trades <- data.frame(NewTeam = '', OldTeam = '', Player = '', Year = '', MatchKey = '', stringsAsFactors = FALSE)

# Loop through very month for every year from 2010 to 2015
for (year in 2010:2015) {
  for (month in 1:12) {
    
    # Get the date specifics
    year.ch <- as.character(year)
    month.ch <- as.character(month)
    endDay.ch <- as.character(numDaysInMonth[month])
    # Fix some of the edge cases: one digit months and leap year
    if (month <= 9) {
      month.ch <- paste('0', month.ch, sep='')
    }
    if (year == 2012 && month == 2) {
      endDay.ch <- as.character(numDaysInMonth[month]+1)
    }
    
    # Construct the date strings
    start_date <- paste(year.ch, month.ch, '01', sep='')
    end_date <- paste(year.ch, month.ch, endDay.ch, sep='')
    
    # This website loads the table data using Javascript. We go directly to the 
    # Jacascript file which provides the data in JSON format.
    url <- paste('http://mlb.mlb.com/lookup/json/named.transaction_all.bam?start_date=',start_date,'&end_date=',end_date,'&sport_code=%27mlb%27', sep='')
    json <- getURL(url)
    Sys.sleep(0.2)
    tempData <- as.data.frame(fromJSON(json))
    
    # Filter all the things we don't want. We are only concerned with trades,
    # we only need the teams involved, the players name and the date of the transaction
    tempData <- tempData %>%
      filter(transaction_all.queryResults.row.type_cd=='TR') %>%
      select(transaction_all.queryResults.row.team, transaction_all.queryResults.row.from_team, transaction_all.queryResults.row.player) %>%
      filter(transaction_all.queryResults.row.player != '') %>%
      mutate(Year = year) %>%
      mutate(MatchKey = paste(transaction_all.queryResults.row.player, Year))
    
    # Set the column names to mach 'trades' and then append the data
    colnames(tempData) <- c('NewTeam', 'OldTeam', 'Player', 'Year', 'MatchKey')
    trades <- rbind(tempData, trades)
  }
}

# Occasionally we get information on minor leagues so we remove those
load("Data/teams.RData")
trades <- trades %>% 
  filter(NewTeam %in% teams$Team.Names) %>%
  filter(OldTeam %in% teams$Team.Names)

# remove all the unecessary variables
remove(tempData, end_date, endDay.ch, json, month, month.ch, numDaysInMonth, start_date, url, year, year.ch, teams)
