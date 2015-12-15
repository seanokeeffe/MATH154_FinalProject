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

# Get first and last name from noisy string
format.names <- function(vec) {
  name.first <- unlist(str_split(vec, "\r"))[1]
  name.last <- tail(unlist(str_split(vec, "\t")), n=1)
  
  c(name.first, name.last)
}

# Get the names of all of the players in the mlb for a certain series of years
get.player.names <- function(years.all = 2010:2015) {
  players.all <- data.frame()
  for(year in years.all){
    cat("Year", year, "\n")
    num <- 1
    while(TRUE) {
      cat("Year", year,"; Num", num, "\n")
      url.string <- paste("http://www.foxsports.com/mlb/players?season=", year, "&page=", num, "&position=0", sep = "")
      web <- getURL(url.string)
      parsedDoc <- readHTMLTable(web, stringsAsFactors=FALSE)
      if(length(parsedDoc) == 0) break
      
      data.table <- parsedDoc[[1]]
      temp <- unname(sapply(data.table$Player, format.names))
      players.to.add <- data.frame(first.name = temp[1,], last.name = temp[2,], 
                                   pos = data.table$Position, stringsAsFactors = FALSE)
      
      players.all <- unique(rbind(players.all, players.to.add))
      num <- num + 1
    }
  }
  players.all
}