install.packages("googlesheets4")
install.packages("leaflet")
install.packages("htmltools")

library(googlesheets4)
library(leaflet)
library(tidyverse)

# Reading Hale's A Tentative Map googlesheet from GDrive
anc_site <- read_sheet("https://docs.google.com/spreadsheets/d/1-IndrwIPgMrh0oBHTwOVBwkd_LslSTepWVSNSMv8Rc4/edit?pli=1#gid=0")


# Splitting up her sites into different symbols
pin <- anc_site %>% 
  filter(`Type of Symbol`== "Pin")
square <- anc_site %>% 
  filter(`Type of Symbol`== "Square")

water <- anc_site %>% 
  filter(`Type of Symbol`== "Water")
tree <- anc_site %>% 
  filter(`Type of Symbol`== "Tree")


# Leaflet below does not work due to package shift 

leaflet() %>%
  addTiles() %>%
  addProviderTiles("Esri.WorldTopoMap", group = "Topo") %>%
  addProviderTiles("Esri.WorldImagery", group = "ESRI Aerial") %>%
  #addProviderTiles("NASAGIBS.ViirsEarthAtNight2012", group = "Night") %>% 
  #addProviderTiles("CartoDB.Positron", group = "CartoDB") %>%
  #addProviderTiles("OpenStreetMap.Mapnik", group = "OpenStreet")%>%
  addAwesomeMarkers(data=pin, group="sites", radius =1, color = "blue", opacity = 0.5,
                   stroke = TRUE, fillColor = "blue")# %>% 
  addCircleMarkers(data=square, radius = 3, opacity = 0.5, color= "black", stroke = TRUE,
                   fillOpacity = 0.5, weight=2, fillColor = "red",
                   popup = paste0("FeatureID: ", rcdata$FeatureID,
                                  "<br> Type: ", rcdata$FeatureType,
                                  "<br> Interpretation: ", rcdata$Interpretation,
                                  "<br> Notes: ", rcdata$Comments)) %>%
  addLayersControl(
    baseGroups = c("Topo","ESRI Aerial", "CartoDB", "OpenStreet", "Night"),
    overlayGroups = c("Features", "Ropeway"),
    options = layersControlOptions(collapsed = T))