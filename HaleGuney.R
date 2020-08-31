library(tidyverse)
library(leaflet)
library(googlesheets4)


x <- read_sheet("https://docs.google.com/spreadsheets/d/1-IndrwIPgMrh0oBHTwOVBwkd_LslSTepWVSNSMv8Rc4/edit#gid=0")

water <- x %>% filter(`Type of Symbol`== "Water")
tree<- x %>% filter(`Type of Symbol`== "Tree")
pin<- x %>% filter(`Type of Symbol`== "Pin")
square<- x %>% filter(`Type of Symbol`== "Square")



HaleSites <- leaflet() %>%
  addTiles() %>%
  addProviderTiles("Esri.WorldTopoMap", group = "Topo") %>%
  addProviderTiles("Esri.WorldImagery", group = "ESRI Aerial") %>%
  addCircleMarkers(lng = water$Longtitude, lat =water$Latitude, group="Water", radius = 4, opacity=1, fill = "darkblue",stroke=TRUE,
                   fillOpacity = 0.75, weight=2, fillColor = "yellow",
                   popup = paste0("Ancient Name: ", water$`Ancient Name`,
                                  "<br> Modern Name: ", water$`Modern Name`,
                                  "<br> Coordinates: ", water$Coordinates)) %>%
  addCircleMarkers(lng = square$Longtitude, lat =square$Latitude, group = "Sites", radius = 5, fillOpacity =1, fillColor = "black", stroke = F,
             popup = paste0("Ancient Name: ", square$`Ancient Name`,
                            "<br> Modern Name: ", square$`Modern Name`,
                            "<br> Coordinates: ", square$Coordinates)) %>% 
  addCircleMarkers(lng = pin$Longtitude, lat = pin$Latitude, group = "Pins", radius = 4,fillOpacity =1, fillColor = "goldenrod",stroke = F,
                   popup = paste0("Ancient Name: ", pin$`Ancient Name`,
                                  "<br> Modern Name: ", pin$`Modern Name`,
                                  "<br> Coordinates: ", pin$Coordinates)) %>%    
  addCircleMarkers(lng = tree$Longtitude, lat = tree$Latitude, group = "Tree", radius = 4,fillOpacity =1, fillColor = "green",stroke = F,
                   popup = paste0("Ancient Name: ", tree$`Ancient Name`,
                                  "<br> Modern Name: ", tree$`Modern Name`,
                                  "<br> Coordinates: ", tree$Coordinates)) %>%    
                     # addControl(position = "bottomleft")
  addScaleBar(position = "bottomright") %>% 
  addLayersControl(
    baseGroups = c("Topo","ESRI Aerial"),
    overlayGroups = c("Sites", "Water", "Pins"),
    options = layersControlOptions(collapsed = T))
  
  
  # SAVE YOUR HTML DOCUMENT
#if you replace line15 with " HaleSites <- leaflet() %>% " then you can save the whole map   
  library(htmlwidgets)
  saveWidget(HaleSites, "HaleSites.html", selfcontained = TRUE)
