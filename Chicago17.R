## CHICAGO HOMICIDES

# Load necessary libraries
library(tidyverse)
library(leaflet)


# Load some data the from Chicago data portal
# https://data.cityofchicago.org/Public-Safety/Crimes-2017/d62x-nvdr
crimes <- read_csv("data/Crimes_-_2017.csv")
glimpse(crimes)

# Filter out homicides only
(homicides <- crimes %>%
    filter(`Primary Type` == "HOMICIDE"))

# Plot on a map letting R Leaflet pick Longitude and Latitude automagically 

# addMarkers() and related functions will automatically check data frames for columns called 
# lng/long/longitude and lat/latitude (case-insensitively). If your coordinate columns have any other names, 
# you need to explicitly identify them using the lng and lat arguments. 
# Such as `addMarkers(lng = ~Longitude, lat = ~Latitude).

leaflet(data = homicides) %>%
  addTiles() %>%
  addMarkers(label = ~Date)


# Customize your icons with The awesome markers plugin. 

# Instead of using addMarkers(), use addAwesomeMarkers() to control the appearance of the markers
# using icons from the Font Awesome, Bootstrap Glyphicons, and Ion icons icon libraries.
#https://github.com/lvoogdt/Leaflet.awesome-markers
#https://ionicons.com/
#https://fontawesome.com/icons?from=io

icons <- awesomeIcons(
  icon = 'bolt',
  iconColor = 'orange',
  markerColor = "black",
  library = 'fa'
)

leaflet(data = homicides) %>%
  addTiles() %>%
  addAwesomeMarkers(icon = icons)


# Cluster your datapoints to prevent overlap and improve readability
leaflet(data = homicides) %>%
  addTiles() %>%
  addMarkers(clusterOptions = markerClusterOptions())

# Add labels
leaflet(data = homicides) %>%
  addTiles() %>%
  addMarkers(clusterOptions = markerClusterOptions(), label = ~Date)


# Add richer labels
leaflet(data = homicides) %>%
  addTiles() %>%
  addMarkers(clusterOptions = markerClusterOptions(), label = paste0("Date:", homicides$Date,
                                                                     "<br> Description:", homicides$Description))

Chicago_homicides2017 <- leaflet(data = homicides) %>%
  addTiles() %>%
  addMarkers(clusterOptions = markerClusterOptions(), label = paste0("Date:", homicides$Date,
                                                                     "<br> Description:", homicides$Description))
Chicago_homicides2017

# SAVE YOUR HTML DOCUMENT
library(htmlwidgets)
saveWidget(Chicago_homicides2017, "Chicago17.html", selfcontained = TRUE)
