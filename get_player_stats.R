

players.pitchers <- filter(players.all, pos == "P")
players.hitters <- filter(players.all, pos != "P")
url.base.1 <- "http://www.baseball-reference.com/players/"
url.base.2 <- "01.shtml"

get.player.urls <- function(players) {
  name.first <- tolower(str_replace_all(players[1], "[[:punct:]]", ""))
  name.last <- tolower(str_replace_all(players[2], "[[:punct:]]", ""))
  name.full <- paste(substr(name.last, 1, 5), substr(name.first, 1, 2), sep = "")
  
  paste(url.base.1, substr(name.full, 1, 1), "/", name.full, url.base.2, sep = "")
}

players.pitchers.urls <- apply(players.pitchers, 1, get.player.urls)
players.hitters.urls <- apply(players.hitters, 1, get.player.urls)

### Function: get.player.stats
get.player.stats <- function(urls.all, players.pos, position = NULL, year) {
  # Throw error if urls.all, players.all not same length
  players.stats <- data.frame()
  for(i in 1:length(urls.all)){
    cat(i, "\n")
    player.name <- paste(players.pos$first.name[i], players.pos$last.name[i])
    player.url <- urls.all[i]
    
    player.web <- ""
    num <- 0
    count <- 0
    while(count <= 1) {
      cat("num", num+1, "\n")
      player.url <- gsub(toString(num), toString(num+1), player.url)
      player.web <- getURL(player.url)
      player.web2 <- unlist(str_split(player.web, "\""))
      count <- length(grep(year, player.web2))
      num <- num + 1
    }
    parsedDoc <- readHTMLTable(player.web, stringsAsFactors=FALSE)
  }
}