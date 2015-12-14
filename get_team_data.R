# MATH154 - Computational Statistics
# Pomona College
# Professor Hardin
#
# Final Project
# Jozi McKiernan, Sean O'Keeffe, Sam Woodman

#-----------------------------------------------------------------------------------------------------
# Data Collection - Getting MLB team data
#-----------------------------------------------------------------------------------------------------

# Load required packages
require(RgoogleMaps)

# Team names, team location, and team color were manually collected and saved in a csv file
teams <- read.csv("teams.csv")

# We add the lat lon location using Google Maps
for (i in 1:nrow(teams)) {
  temp_loc <- GetMap(center = as.character(teams$Location[i]), zoom=11)
  teams$lat[i] <- temp_loc$lat.center
  teams$lon[i] <- temp_loc$lon.center
}
remove(i, temp_loc)
