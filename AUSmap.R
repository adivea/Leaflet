## Testing Aussie Map display - SYDNEY HARBOUR

# Attach libraries
library(leaflet)
library(tidyverse)

AUS_wms <- "http://www.environment.gov.au/mapping/services/ogc_services/World_Heritage_Areas_label/MapServer/WMSServer?service=WMS&version=1.3.0&request=GetCapabilities"

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
  
  
  ###################### GRAB OTHER AUSSIE WMS TILES DATA - UNFINISHED NEEDS WORK!
  
 l_aus %>% 
    addWMSTiles(baseURL=AUS_wms,
        layers = c(0),
      options = WMSTileOptions(format = "image/png"),
      attribution = "Source: GIS Geoservices Informatie Vlaanderen") %>%
    addControl("Leuven on the Vandermaelen map (1846-1854)", position = "topright")

 #####################################################
 #
 # Task 1: Create a Danish equivalent with esri layers
 # Task 2: Read in the googlesheet data you and your colleagues created 