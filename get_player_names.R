# MATH154 - Computational Statistics
# Pomona College
# Professor Hardin
#
# Final Project
# Jozi McKiernan, Sean O'Keeffe, Sam Woodman

#-----------------------------------------------------------------------------------------------------
# Data Collection - Getting players in MLB
#-----------------------------------------------------------------------------------------------------

# Packages are loaded in final_project.R

baseball.teams <- c("ARI", "ATL", "BAL", "BOS", "CHC", "CHW", "CIN", "CLE", "COL", "DET", 
                    "FLA", "HOU", "KCR", "LAA", "LAD", "MIL", "MIN", "NYM", "NYY", "OAK", 
                    "PHI", "PIT", "SDP", "SFG", "SEA", "STL", "TBR", "TEX", "TOR", "WSN")
players.hitters <- players.pitchers <- data.frame()

for(year in 2010:2015) {
  # Update team codes if necessary-see Baseball Team Abbreviations.txt
  if(year == 2012) baseball.teams[11] <- "MIA"
  for(team in baseball.teams) {
    cat("year:", year, "; team:", team, "\n")
    # Get team roster
    # Ex: 2010 Dodgers: web.team <- getURL("http://www.baseball-reference.com/teams/LAD/2010.shtml")
    url.string <- paste("http://www.baseball-reference.com/teams/", team, "/", year, ".shtml", sep = "")
    web.team <- getURL(url.string)
    parsedDoc.team <- readHTMLTable(web.team, stringsAsFactors=FALSE)
    
    # Hitters
    team.hitter <- parsedDoc.team$team_batting %>% filter(Rk != "Rk", !(Pos %in% c("P", "")))
    team.hitter$Hand <- unname(sapply(team.hitter$Name, function(x) ifelse(grepl("\\*", x), "L", 
                                                                           ifelse(grepl("#", x), "S", "R"))))
    team.hitter$Name <- unname(sapply(team.hitter$Name, function(y) gsub("\\*|#|?", "", y)))
    name.hitter <- unname(sapply(team.hitter$Name, function(z) unlist(regmatches(z, regexpr(" ", z), 
                                                                                 invert = TRUE))))
    
    team.hitter.to.add <- data.frame(name.first = name.hitter[1,], 
                                     name.last = name.hitter[2,], 
                                     hand = team.hitter$Hand,
                                     pos = team.hitter$Pos, 
                                     stringsAsFactors = FALSE)
    players.hitters <- unique(rbind(players.hitters, team.hitter.to.add))
    
    # Pitchers
    team.pitcher <- parsedDoc.team$team_pitching %>% filter(Rk != "Rk")
    team.pitcher$Hand <- unname(sapply(team.pitcher$Name, function(a) ifelse(grepl("\\*", a), "L", 
                                                                             ifelse(grepl("#", a), "S", "R"))))
    team.pitcher$Name <- unname(sapply(team.pitcher$Name, function(b) gsub("\\*|#|?", "", b)))
    name.pitcher <- unname(sapply(team.pitcher$Name, function(z) unlist(regmatches(z, regexpr(" ", z), 
                                                                                   invert = TRUE))))
    
    team.pitcher.to.add <- data.frame(name.first = name.pitcher[1,], 
                                      name.last = name.pitcher[2,], 
                                      hand = team.pitcher$Hand,
                                      pos = "P",
                                      stringsAsFactors = FALSE)
    players.pitchers <- unique(rbind(players.pitchers, team.pitcher.to.add))
  }
}

rm(list=setdiff(ls(), c("players.pitchers", "players.hitters")))
