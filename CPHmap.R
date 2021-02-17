###############################################
#      Map of Copenhagen baths
#
###############################################

# Activate libraries
library(leaflet)
library(tidyverse)
library(htmltools)
library(googlesheets4)


# Bring in a choice of Esri background layers  
l_cp <- leaflet() %>%   # assign the base location to an object
  setView(12.56553, 55.675946, zoom = 11)
#l_cp %>% addTiles()

esri <- grep("^Esri", providers, value = TRUE)
for (provider in esri) {
  l_cp <- l_cp %>% addProviderTiles(provider, group = provider)
}


# Create the map
MapCPH <- l_cp %>%
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

MapCPH

# test adding points
MapCPH %>% addAwesomeMarkers(lng = c(12.34, 12.23, 12.11),
                            lat = c(55.82, 55.63, 55.49), 
                            popup = c("Mary", "Magnus", "Monty"))



#####################################################
#
# Task 1: Bring in a choice of stamen background layers ?

#####################################################
#
# Task 2: Bring in bathhouse points for Copenhagen

# Load data from Googlesheet (deauthorize your connection if read_sheet gives you trouble)
baths <- read_sheet("https://docs.google.com/spreadsheets/d/15i17dqdsRYv6tdboZIlxTmhdcaN-JtgySMXIXwb5WfE/edit#gid=0",
                    col_types = "ccnncnnnc")
glimpse(baths)

# Read the bath coordinates and names into map
MapCPH %>% addCircleMarkers(lng=baths$Longitude,
                           lat=baths$Latitude,
                           popup = baths$BathhouseName)


# Save map as a html document (optional, replacement of pushing the export button)
# only works in root

saveWidget(MapCPH, "Copenhagenmap.html", selfcontained = TRUE)

