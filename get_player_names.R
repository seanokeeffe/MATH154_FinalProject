
library(XML)
library(dplyr)
library(tidyr)
library(mosaic)
library(RCurl)
library(stringr)

format.names <- function(vec) {
  name.first <- unlist(str_split(vec, "\r"))[1]
  name.last <- tail(unlist(str_split(vec, "\t")), n=1)
  
  c(name.first, name.last)
}

get.player.names <- function(years.all = 2010:2015) {
  players.all <- data.frame()
  for(year in years.all){
    cat("Year", year, "\n")
    num <- 1
    while(TRUE) {
      cat("Num", num, "\n")
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