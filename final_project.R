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

# Functions used to get the names of all players in the MLB between 2010 and 2015.
source('get_player_names.R', local=TRUE, echo=FALSE)

# Functions used to get the stats of all players in the MLB between 2010 and 2015
source('get_player_stats.R', local=TRUE, echo=FALSE)

# Split players by pitcher and hitter
players.pitchers <- filter(players.all.names, pos == "P")
players.hitters <- filter(players.all.names, pos != "P")
url.base.1 <- "http://www.baseball-reference.com/players/"
url.base.2 <- "01.shtml"

# Get player urls
players.pitchers.urls <- apply(players.pitchers, 1, get.player.urls)
players.hitters.urls <- apply(players.hitters, 1, get.player.urls)

# Get player stats
players.stats.pitcher <- get.player.stats(players.pitchers.urls[1:500], players.pitchers[1:500,], 2010:2015)
players.stats.hitter <- get.player.stats(players.hitters.urls, players.hitters, 2010:2015)

# Filter pitcher stats for desired stats
players.stats.pitcher.test <- players.stats.pitcher1 %>% 
  mutate(`SHO/G` = R/PA) %>% 
  mutate(`SV/G` = `2B`/PA) %>% 
  select(Age, `W-L%`, ERA, `SHO/G`, `SV/G`, FIP, WHIP, `H9`, `HR9`, `BB9`, `SO9`)

# Filter hitter stats for desired stats
players.stats.hitter <- players.stats.hitter %>% 
  mutate(`R/PA` = R/PA) %>% 
  mutate(`2B/PA` = `2B`/PA) %>% 
  mutate(`3B/PA` = `3B`/PA) %>% 
  mutate(`HR/PA` = HR/PA) %>% 
  mutate(`RBI/PA` = RBI/PA) %>% 
  mutate(`SB/PA` = SB/PA) %>% 
  mutate(`SO/PA` = SO/PA) %>% 
  select(Age, BA, OBP, `R/PA`, `2B/PA`, `3B/PA`, `HR/PA`, `RBI/PA`, `SB/PA`, `SO/PA`)