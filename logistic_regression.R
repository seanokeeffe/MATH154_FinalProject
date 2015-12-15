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
require(dplyr)
set.seed(42)

# Cross validation function
crossValid <- function(d) {
  d = sample(d)
  k = 10
  step = floor(nrow(d)/10)-1
  cutoff_errors = c()
  
  for (c in (1:100)/100) {
    errors = c()
    s_index = 1
    e_index = s_index + step
    for (i in 1:k) {
      temp_train = d[-c(s_index:e_index),]
      temp_test = d[s_index:e_index,]
      temp_fit = glm(traded~., data = temp_train, family = binomial)
      temp_pred = predict(temp_fit, newdata = temp_test, type = "response")
      temp_table = table(temp_pred > c, temp_test$traded)
      if (nrow(temp_table) == 1) {
        if ((temp_pred > c)[1]) {
          errors = c(errors, temp_table[1,1]/nrow(temp_test))
        } else {
          errors = c(errors, temp_table[1,2]/nrow(temp_test))
        }
      } else {
        errors = c(errors, (temp_table[1,2]+temp_table[2,1])/nrow(temp_test))
      }
      s_index = e_index + 1
      e_index = s_index + step
    }
    cutoff_errors = c(cutoff_errors, mean(errors))
  }
  
  return(which(cutoff_errors == min(cutoff_errors))/100)
}


# run get_trade_data and GetData to get trades, players.hitters.stats, and players.pitchers.stats data frames

#-------------------------BATTERS-------------------------

# wrangle/mutate batter data 
players.hitters.stats = mutate(players.hitters.stats, player.year = paste(player, Year))
players.hitters.stats = mutate(players.hitters.stats, traded = 0 + player.year %in% trades$MatchKey)

# Create factor variable for whether or not a player was traded
players.hitters.stats$traded = as.factor(players.hitters.stats$traded)
players.hitters.stats = na.omit(players.hitters.stats)

# Remove categorical predictors and misleading, repetitive, 
# and/or don't make sense from a baseball standpoint predictors
players.hitters.stats = select(players.hitters.stats, Age, BA, OBP, `R/PA`, `RBI/PA`,`2B/PA`,`3B/PA`,`HR/PA`,`SB/PA`,`SO/PA`, traded)

# Cross validation-------------------------------------------------------------------
# Run one time to select cutoff parameter
# crossValid(players.hitters.stats)

#logistic regression for batters
glm.fit.bat = glm(traded~., data=players.hitters.stats, family=binomial)

#print confusion matrix
table(predict(glm.fit.bat, type = "response")>.4, players.hitters.stats$traded)


#--------------------------PITCHERS--------------------------

#wrangle and mutate pitcher data
players.pitchers.stats = mutate(players.pitchers.stats, player.year = paste(player, Year))
players.pitchers.stats = mutate(players.pitchers.stats, traded = 0 + player.year %in% trades$MatchKey)

# Create factor variable for whether or not a player was traded
players.pitchers.stats$traded = as.factor(players.pitchers.stats$traded)
players.pitchers.stats = na.omit(players.pitchers.stats)


# Remove categorical predictors and misleading/don't make sense from a baseball standpoint predictors
players.pitchers.stats = select(players.pitchers.stats, Age, `W-L%`, ERA, FIP, WHIP, H9, HR9, BB9, SO9, traded, `SHO/G`, `SV/G`)

# Cross validation-------------------------------------------------------------------
# Run one time to select cutoff parameter
# crossValid(players.pitchers.stats)

#logistic regression for pitchers
glm.fit.pitch = glm(traded~., data =players.pitchers.stats, family=binomial)

#print confusion matrix
table(predict(glm.fit.pitch, type = "response")>.4, players.pitchers.stats$traded)

