# MATH154 - Computational Statistics
# Pomona College
# Professor Hardin
#
# Final Project
# Jozi McKiernan, Sean O'Keeffe, Sam Woodman

#-----------------------------------------------------------------------------------------------------
# Data Collection - Getting player statistics for MLB
#-----------------------------------------------------------------------------------------------------

# Packages are loaded in final_project.R

# Takes a row of player name data and creates url string
get.player.urls <- function(players) {
  name.first <- tolower(players[1])
  name.last <- tolower(players[2])
  name.full <- paste(substr(name.last, 1, 5), substr(name.first, 1, 2), sep = "")
  
  paste(url.base.1, substr(name.full, 1, 1), "/", name.full, url.base.2, sep = "")
}

# Get correct url for a single player
get.webpage.data <- function(player.url, player.name, years) {
  idx <- 1
  while(TRUE) {
    player.web <- getURL(player.url)
    # Check player has right name
    name.correct <- grepl(player.name, player.web)
    # Check player is from right era
    player.web.split <- unlist(str_split(player.web, "\""))
    count <- 0
    for(year in years) {
      count <- count + length(grep(year, player.web.split))
    }
    # If player appears to be correct player: break
    if(count >= 25 & name.correct) break
    
    # Else increment url index
    idx <- idx + 1
    if(idx >= 7) {
      cat("Index of player url is greater than 7", "\n")
      player.web <- ""
      break
    }
    x <- paste("0", idx-1, sep = "")
    y <- paste("0", idx, sep = "")
    player.url <- gsub(toString(x), toString(y), player.url)
  }
  player.web
}

### Get statistics given vector of urls, data frame, and vector of years to get stats for
get.player.stats <- function(urls.all, players.pos, years) {
  num.urls <- length(urls.all)
  if(num.urls != nrow(players.pos)) stop(message = "Number of urls does not equal number of players")
  players.stats <- NULL
  for(i in 1:num.urls){
    player.name <- paste(players.pos$name.first[i], players.pos$name.last[i])
    cat(i, "out of", num.urls, ":", player.name, "\n")
    player.pos <- players.pos$pos[i]
    player.url <- urls.all[i]
    
    ## Get right player
    player.web <- get.webpage.data(player.url, player.name, years)
    if(player.web != "") {
      parsedDoc <- readHTMLTable(player.web, stringsAsFactors=FALSE)
      
      ## Get stats
      # Hitters or Pitchers
      if(player.pos != "P") stats.current <- parsedDoc$batting_standard
      if(player.pos == "P") stats.current <- parsedDoc$pitching_standard  
      if(!is.null(stats.current)) {
        if(player.pos != "P") stats.current[-c(3, 4, 29, 30)] <- 
            apply(stats.current[-c(3, 4, 29, 30)], 2, extract_numeric)
        if(player.pos == "P") stats.current[-c(3, 4, 35)] <- 
            apply(stats.current[-c(3, 4, 35)], 2, extract_numeric)
        
        # Filter data by league and years
        stats.current <- stats.current %>% 
          filter(Lg %in% c("AL", "NL", "MLB")) %>%
          filter(Year %in% years) %>% 
          mutate(player = player.name)
        stats.current <- stats.current[!(stats.current$Tm == "TOT"),]
        stats.current <- stats.current[!duplicated(stats.current$Year),]
        
        # Add to existing data set
        if(is.null(players.stats) | (length(stats.current) == length(players.stats))) 
          players.stats <- rbind(players.stats, stats.current)
      }
    }
    Sys.sleep(0.2) 
  }
  players.stats
}