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


# run get_trade_data and GetData to get trades, stats.all.bat, and stats.all.pitch data frames

#-------------------------BATTERS-------------------------

# wrangle/mutate batter data 
stats.all.bat = mutate(stats.all.bat, player.year = paste(player, Year))
stats.all.bat = mutate(stats.all.bat, traded = 0 + player.year %in% trades$MatchKey)
# stats.all.bat = mutate(stats.all.bat, "2B/PA" = `2B` / PA)
# stats.all.bat = mutate(stats.all.bat, "3B/PA" = `3B` / PA)
# stats.all.bat = mutate(stats.all.bat, "HR/PA" = HR / PA)
# stats.all.bat = mutate(stats.all.bat, "R/PA" = R / PA)
# stats.all.bat = mutate(stats.all.bat, "RBI/PA" = RBI / PA)
# stats.all.bat = mutate(stats.all.bat, "SB/PA" = SB / PA)
# stats.all.bat = mutate(stats.all.bat, "SO/PA" = SO / PA)

# Create factor variable for whether or not a player was traded
stats.all.bat$traded = as.factor(stats.all.bat$traded)
stats.all.bat = na.omit(stats.all.bat)

# Remove categorical predictors and misleading, repetitive, 
# and/or don't make sense from a baseball standpoint predictors
stats.all.bat = select(stats.all.bat, Age, BA, OBP, `R/PA`, `RBI/PA`,`2B/PA`,`3B/PA`,`HR/PA`,`SB/PA`,`SO/PA`, traded)

#logistic regression for batters
glm.fit.bat = glm(traded~., data =stats.all.bat, family=binomial)

#print confusion matrix
table(predict(glm.fit.bat, type = "response")>.4, stats.all.bat$traded)


#--------------------------PITCHERS--------------------------

#wrangle and mutate pitcher data
stats.all.pitch = mutate(stats.all.pitch, player.year = paste(player, Year))
stats.all.pitch = mutate(stats.all.pitch, traded = 0 + player.year %in% trades$MatchKey)
# stats.all.pitch = mutate(stats.all.pitch, "SHO/G" = SHO / G)
# stats.all.pitch = mutate(stats.all.pitch, "SV/G" = SV / G)

# Create factor variable for whether or not a player was traded
stats.all.pitch$traded = as.factor(stats.all.pitch$traded)
stats.all.pitch = na.omit(stats.all.pitch)


# Remove categorical predictors and misleading/don't make sense from a baseball standpoint predictors
stats.all.pitch = select(stats.all.pitch, Age, `W-L%`, ERA, FIP, WHIP, H9, HR9, BB9, SO9, traded, `SHO/G`, `SV/G`)


#logistic regression for pitchers
glm.fit.pitch = glm(traded~., data =stats.all.pitch, family=binomial)

#print confusion matrix
table(predict(glm.fit.pitch, type = "response")>.4, stats.all.pitch$traded)

