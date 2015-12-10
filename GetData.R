# CompStats Final Project
# Jozi, Sam, and Sean

library(XML)
library(dplyr)
library(tidyr)
library(mosaic)
library(RCurl)
library(stringr)

baseball.teams <- c("ARI", "ATL", "BAL", "BOS", "CHC", "CHW", "CIN", "CLE", "COL", "DET", 
                    "FLA", "HOU", "KCR", "LAA", "LAD", "MIL", "MIN", "NYM", "NYY", "OAK", 
                    "PHI", "PIT", "SDP", "SFG", "SEA", "STL", "TBR", "TEX", "TOR", "WSN")
stats.all.bat <- stats.all.pitch <- data.frame()
# test
#year <- 2010
#team <- "CHW"

for(year in 2010:2015) {
  # Update team codes if necessary-see Baseball Team Abbreviations.txt
  #if(year == 2012) baseball.teams[11] <- "MIA"
  
  for(team in baseball.teams) {
    # Get team roster
    # Ex: 2010 Dodgers: web.team <- getURL("http://www.baseball-reference.com/teams/LAD/2010.shtml")
    url.string <- paste("http://www.baseball-reference.com/teams/", team, "/", year, ".shtml", sep = "")
    web.team <- getURL(url.string)
    parsedDoc.team <- readHTMLTable(web.team, stringsAsFactors=FALSE)
    # Hitters
    stats.team.bat <- parsedDoc.team$team_batting %>% filter(Rk != "Rk", !(Pos %in% c("P", "")))
    stats.team.bat$Hand <- unname(sapply(stats.team.bat$Name, function(x) ifelse(grepl("\\*", x), "L", 
                                                                                 ifelse(grepl("#", x), "S", "R"))))
    num.bat <- nrow(stats.team.bat)
    # Pitchers
    stats.team.pitch <- parsedDoc.team$team_pitching %>% filter(Rk != "Rk")
    stats.team.pitch$Hand <- unname(sapply(stats.team.pitch$Name, function(y) ifelse(grepl("\\*", y), "L", 
                                                                                     ifelse(grepl("#", y), "S", "R"))))
    num.pitch <- nrow(stats.team.pitch)
    player.names.bat <- strsplit(stats.team.bat$Name, " ")
    player.names.pitch <- strsplit(stats.team.pitch$Name, " ")
    
    # Generate vector of web IDs for hitters
    url.team.bat <- c()
    for(i in player.names.bat) {
      i.low <- tolower(str_replace_all(i, "[[:punct:]]", ""))
      url.team.bat <- c(url.team.bat, paste(substr(i.low[2], 1, 5), 
                                            substr(i.low[1], 1, 2), sep = ""))
    }
    # Generate vector of web IDs for pitchers
    url.team.pitch <- c()
    for(j in player.names.pitch) {
      j.low <- tolower(str_replace_all(j, "[[:punct:]]", ""))
      url.team.pitch <- c(url.team.pitch, paste(substr(j.low[2], 1, 5), 
                                                substr(j.low[1], 1, 2), sep = ""))
    }
    
    # Generate full web address for each player
    url.base.1 <- "http://www.baseball-reference.com/players/"
    url.base.2 <- "01.shtml"
    url.team.bat.complete <- c()
    for(k in url.team.bat) {
      url.team.bat.complete <- c(url.team.bat.complete, 
                                 paste(url.base.1, substr(k, 1, 1), "/", k, url.base.2, sep = ""))
    }
    url.team.pitch.complete <- c()
    for(l in url.team.pitch) {
      url.team.pitch.complete <- c(url.team.pitch.complete, 
                                   paste(url.base.1, substr(l, 1, 1), "/", l, url.base.2, sep = ""))
    }
    
    # Get hitter statistics
    for(x in 1:num.bat) {
      a <- url.team.bat.complete[x]
      player.name <- str_replace_all(stats.team.bat$Name[x], "[[:punct:]]", "")
      stats.current <- NULL
      
      if(!(player.name %in% stats.all.bat$player)) {
        web.player <- getURL(a)
        if(web.player == "") web.player <- getURL(str_replace_all(a, "1", "2"))
        # If neither address works, ignore hitter
        if(web.player != "") {
          parsedDoc <- readHTMLTable(web.player, stringsAsFactors=FALSE)
          stats.current <- parsedDoc$batting_standard
          
          # Filter data: year: 2010-2015
          stats.current[-c(3, 4, 29, 30)] = apply(stats.current[-c(3, 4, 29, 30)], 2, extract_numeric)
          stats.current <- stats.current %>% 
            filter(Lg %in% c("AL", "NL", "MLB")) %>%
            filter(Year %in% 2010:2015) %>% 
            mutate(player = player.name)
          
          # Add to existing hitter data set
          stats.all.bat <- rbind(stats.all.bat, stats.current)
        }
      }
    }
    
    # Get pitcher statistics
    for(y in 1:num.pitch) {
      b <- url.team.pitch.complete[y]
      player.name <- str_replace_all(stats.team.pitch$Name[y], "[[:punct:]]", "")
      stats.current <- NULL
      
      if(!(player.name %in% stats.all.pitch$player)) {
        web.player <- getURL(b)
        if(web.player == "") web.player <- getURL(str_replace_all(b, "1", "2"))
        # If neither address works, ignore hitter
        if(web.player != "") {
          parsedDoc <- readHTMLTable(web.player, stringsAsFactors=FALSE)
          stats.current <- parsedDoc$pitching_standard
          
          if(!is.null(stats.current)) {
            # Filter data: year: 2010-2015
            stats.current[-c(3, 4, 35)] = apply(stats.current[-c(3, 4, 35)], 2, extract_numeric)
            stats.current <- stats.current %>% 
              filter(Lg %in% c("AL", "NL", "MLB")) %>%
              filter(Year %in% 2010:2015) %>% 
              mutate(player = player.name)
            
            # Add to existing pitcher data set
            stats.all.pitch <- rbind(stats.all.pitch, stats.current)
          }
        }
      }
    }
  }
}