###   GETTING STARTED WITH LEAFLET


# Packages (uncomment if you need the packages)
# install.packages("leaflet")
# install.packages("htmlwidgets")

# Load necessary libraries
library(tidyverse)
library(leaflet)


## Review what backgrounds are available:
# https://leaflet-extras.github.io/leaflet-providers/preview/
# beware that some need extra options specified



## SYDNEY WITH SETVIEW
leaflet() %>%
  addTiles() %>%
  addProviderTiles("Esri.WorldImagery", 
                   options = providerTileOptions(opacity=0.5)) %>% 
  setView(lng = 151.005006, lat = -33.9767231, zoom = 10)



## EUROPE WITH LAYERS AND CONTROL MENU
leaflet() %>% 
  addTiles() %>% 
  setView( lng = 2.34, lat = 48.85, zoom = 5 ) %>% 
  addProviderTiles("Esri.WorldPhysical", group = "Physical") %>% 
  addProviderTiles("Esri.WorldImagery", group = "Aerial") %>% 
  addProviderTiles("MtbMap", group = "Geo") %>% 
  
  addLayersControl(
    baseGroups = c("Geo","Aerial", "Physical"),
    options = layersControlOptions(collapsed = T))


## EUROPE EXAMPLE WITH SIMPLE MANUALLY CREATED MARKERS
popup = c("Robin", "Jakub", "Jannes")

leaflet() %>%
  addProviderTiles("Esri.WorldPhysical") %>% 
  addAwesomeMarkers(lng = c(-3, 23, 11), # note that you can feed plain Lat Long columns into Leaflet
                    lat = c(52, 53, 49), 
                    popup = popup) %>% 
  addProviderTiles("Esri.WorldPhysical", group = "Physical") %>% 
  addProviderTiles("Esri.WorldImagery", group = "Aerial") %>% 
  addProviderTiles("MtbMap", group = "Geo") %>% 
  
  addLayersControl(
    baseGroups = c("Geo","Aerial", "Physical"),
    options = layersControlOptions(collapsed = T))




## CHICAGO HOMICIDES

# Load some data the from Chicago data portal https://data.cityofchicago.org/Public-Safety/Crimes-2017/d62x-nvdr
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
                                                                     " Description:", homicides$Description))

Chicago_homicides2017 <- leaflet(data = homicides) %>%
  addTiles() %>%
  addMarkers(clusterOptions = markerClusterOptions(), label = paste0("Date:", homicides$Date,
                                                                     " Description:", homicides$Description))
Chicago_homicides2017

# SAVE YOUR HTML DOCUMENT
library(htmlwidgets)
saveWidget(Chicago_homicides2017, "Chicago17.html", selfcontained = TRUE)
