###   GETTING STARTED WITH LEAFLET


## Choose favorite backgrounds in:
# https://leaflet-extras.github.io/leaflet-providers/preview/
## beware that some need extra options specified

# Packages
install.packages("leaflet")

# Go
library(leaflet)

popup = c("Robin", "Jakub", "Jannes")

leaflet() %>%
  addProviderTiles("Esri.WorldPhysical") %>% 
 #addProviderTiles("Esri.WorldImagery") %>% 
  addAwesomeMarkers(lng = c(-3, 23, 11),
                    lat = c(52, 53, 49), 
                    popup = popup)


## Navigate to Sydney
leaflet() %>%
  addTiles() %>%
  addProviderTiles("Esri.WorldImagery", 
                   options = providerTileOptions(opacity=0.5)) %>% 
  setView(lng = 151.005006, lat = -33.9767231, zoom = 10)


# Background: Europe
leaflet() %>% 
  addTiles() %>% 
  setView( lng = 2.34, lat = 48.85, zoom = 5 ) %>% 
  addProviderTiles("Esri.WorldPhysical", group = "Physical") %>% 
  addProviderTiles("Esri.WorldImagery", group = "Aerial") %>% 
  addProviderTiles("MtbMap", group = "Geo") %>% 

addLayersControl(
  baseGroups = c("Geo","Aerial", "Physical"),
  options = layersControlOptions(collapsed = T))
