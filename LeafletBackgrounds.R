###   GETTING STARTED WITH LEAFLET


# Packages (uncomment if you need the packages)
install.packages("leaflet")
install.packages("htmlwidgets")
install.packages("tidyverse")

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
                    lat = c(54, 53, 49), 
                    popup = popup) %>% 
  addProviderTiles("Esri.WorldPhysical", group = "Physical") %>% 
  addProviderTiles("Esri.WorldImagery", group = "Aerial") %>% 
  addProviderTiles("MtbMap", group = "Geo") %>% 
  
  addLayersControl(
    baseGroups = c("Geo","Aerial", "Physical"),
    options = layersControlOptions(collapsed = T))

########################## SYDNEY HARBOUR DISPLAY WITH LAYERS

# Set the location and zoom level
leaflet() %>% 
  setView(151.2339084, -33.85089, zoom = 13) %>%
  addTiles()  # checking I am in the right area


# Bring in a choice of esri background layers  

l_aus <- leaflet() %>%   # assign the base location to an object
  setView(151.2339084, -33.85089, zoom = 13)


esri <- grep("^Esri", providers, value = TRUE)

for (provider in esri) {
  l_aus <- l_aus %>% addProviderTiles(provider, group = provider)
}

l_aus %>%
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
                        }")
addControl("", position = "topright")


# SAVE YOUR HTML MAP DOCUMENT
library(htmlwidgets)
saveWidget(AUSmap, "AUSmap.html", selfcontained = TRUE)

