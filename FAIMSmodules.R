###   GETTING STARTED WITH LEAFLET


## Choose favorite backgrounds in:
# https://leaflet-extras.github.io/leaflet-providers/preview/
## beware that some need extra options specified

# Packages
# install.packages("leaflet")
# install.packages("htmlwidgets")

# Load libraries
library(leaflet)
library(tidyverse)

# Get Locations data from Github

faims <- read_csv("https://raw.githubusercontent.com/adivea/Leaflet/master/data/FaimsList.csv")

# eliminate NAs where location info is missing
faims <- faims %>% 
  filter(!is.na(Lat))

# create a map object
faimsmap <- leaflet() %>%
  setView(lng = 22.34, lat = 28.85, zoom = 2) %>% 
  addProviderTiles("Stamen.TonerBackground", group="Background") %>% 
  addProviderTiles("Stamen.TonerLite", group = "Lite") %>% 
  addProviderTiles("Stamen.Watercolor", group = "Watercolor") %>% 
  addCircleMarkers(lng = faims$Long,
                    lat = faims$Lat,
                    popup = faims$Name) %>% 

  addLayersControl(
    baseGroups = c("Watercolor","Background","Lite"),
    options = layersControlOptions(collapsed = T))

faimsmap

# save map as a html document (optional, replacement of pushing the export button)
# only works in root
library(htmlwidgets)
saveWidget(faimsmap, "faimsmap.html", selfcontained = TRUE)
