## Lets map Denmark

# Activate libraries
library(leaflet)
library(tidyverse)
library(htmlwidgets)


# Bring in a choice of Esri background layers  

l_dk <- leaflet() %>%   # assign the base location to an object
   setView(11, 56, zoom = 7)
#l_dk %>% addTiles()

esri <- grep("^Esri", providers, value = TRUE)
for (provider in esri) {
  l_dk <- l_dk %>% addProviderTiles(provider, group = provider)
}

# l_dk

# Create the map
MapDK <- l_dk %>%
  addLayersControl(baseGroups = names(esri),
                   options = layersControlOptions(collapsed = FALSE)) %>%
  addMiniMap(tiles = esri[[1]], toggleDisplay = TRUE,
             position = "bottomright") %>%
  addMeasure(
    position = "bottomleft",
    primaryLengthUnit = "meters",
    primaryAreaUnit = "sqmeters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") %>% 
  htmlwidgets::onRender("
                        function(el, x) {
                        var myMap = this;
                        myMap.on('baselayerchange',
                        function (e) {
                        myMap.minimap.changeLayer(L.tileLayer.provider(e.name));
                        })
                        }")%>%
addControl("", position = "topright")

MapDK
MapDK %>% addAwesomeMarkers(lng = c(10.34, 10.23, 10.11),
                            lat = c(55.52, 55.53, 55.49), 
                            popup = c("Mary", "Magnus", "Monty"))


# Save map as a html document (optional, replacement of pushing the export button)
# only works in root

saveWidget(MapDK, "DKmap.html", selfcontained = TRUE)

#####################################################
#
# Task 1: Bring in a choice of stamen background layers ?
# Task 2: Bring in point data 

library(googlesheets4)

baths <- read_sheet("https://docs.google.com/spreadsheets/d/15i17dqdsRYv6tdboZIlxTmhdcaN-JtgySMXIXwb5WfE/edit#gid=0",
                     col_types = "ccnncnnnc")
glimpse(baths)

MapDK %>% addCircleMarkers(lng=baths$Longitude,
                           lat=baths$Latitude)
