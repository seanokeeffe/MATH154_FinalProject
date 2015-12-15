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

# Required packages
require(RCurl)
require(jsonlite)
require(dplyr)
require(XML)
require(tidyr)
require(mosaic)
require(stringr)


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

# Get the names of all players in the MLB between 2010 and 2015.
# players.hitters is data frame of hitter first names, last names, position, and hitting style
# players.pitchers is data frame of pitcher first names, last names, position ("P"), and pitching hand
source('Google Drive/Semester 7/MATH154-Comp Stats/MATH154_FinalProject_Git/get_player_names.R', local=TRUE, echo=FALSE)

# Functions used to get the stats of all players in the MLB between 2010 and 2015
source('get_player_stats.R', local=TRUE, echo=FALSE)

# Split players by pitcher and hitter
url.base.1 <- "http://www.baseball-reference.com/players/"
url.base.2 <- "01.shtml"

# Get player urls
players.hitters.urls <- unname(apply(players.hitters, 1, get.player.urls))
players.pitchers.urls <- unname(apply(players.pitchers, 1, get.player.urls))

# Get player stats
players.hitters.stats <- get.player.stats(players.hitters.urls, players.hitters, 2010:2015)
players.pitchers.stats <- get.player.stats(players.pitchers.urls, players.pitchers, 2010:2015)

# Filter hitter stats for desired stats
players.hitters.stats <- players.hitters.stats %>% 
  mutate(`R/PA` = R/PA) %>% 
  mutate(`2B/PA` = `2B`/PA) %>% 
  mutate(`3B/PA` = `3B`/PA) %>% 
  mutate(`HR/PA` = HR/PA) %>% 
  mutate(`RBI/PA` = RBI/PA) %>% 
  mutate(`SB/PA` = SB/PA) %>% 
  mutate(`SO/PA` = SO/PA) %>% 
  select(Year, Age, BA, OBP, `R/PA`, `2B/PA`, `3B/PA`, `HR/PA`, `RBI/PA`, `SB/PA`, `SO/PA`)
# Filter pitcher stats for desired stats
players.pitchers.stats <- players.pitchers.stats %>% 
  mutate(`SHO/G` = SHO/G) %>% 
  mutate(`SV/G` = SV/G) %>% 
  select(Year, Age, `W-L%`, ERA, `SHO/G`, `SV/G`, FIP, WHIP, `H9`, `HR9`, `BB9`, `SO9`)