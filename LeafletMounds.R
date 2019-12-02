###   PLOTTING IN LEAFLET USING BULGARIAN MOUND DATA
##
##    Adela Sobotkova, @TRAP2017, data acquired using the TRAP Burial module
##    https://github.com/FAIMS/burial
  

# packages

install.packages("tidyverse")
install.packages("leaflet")
install.packages("htmltab")
install.packages("sf")


# load libraries

suppressMessages({
  library(tidyverse)
  library(sf)
  library(htmltab)
})

getwd()


# Prepare the data

# Read data
mounds_raw <- read.csv("data/ElenovoMounds_cleaned.csv", stringsAsFactors = FALSE)

# Check that coordinate fields are numbers
cols.num<- c("Longitude","Latitude", "Northing", "Easting")
mounds_raw[cols.num]<-sapply(mounds_raw[cols.num], as.numeric) # ensure that the coordinates are coming through as numeric datatype

# Check for and eliminate NAs
which(is.na(cols.num))  # see if there are some NA's where there are no coordinates available
 

# Transform dataframe into a spatial feature and project to Web Mercator.  
# We need to do that because Leaflet basemaps are 3D

mounds <- st_as_sf(mounds, coords = c("Longitude", "Latitude"),  crs = 4326)
st_crs(mounds)
mounds


# Plot the data

plot(mounds$geometry, pch = 2, cex = sqrt(mounds$HeightMax))


# Plot the mounds in Leaflet

library(leaflet)

leaflet() %>%
  addTiles() %>%
  addProviderTiles("Esri.WorldTopoMap", group = "Topo") %>%
  addProviderTiles("Esri.WorldImagery", group = "ESRI Aerial") %>%
  addCircleMarkers(data=mounds, radius = mounds$HeightMax*1.5, 
                   opacity = 0.5, color= "black", stroke = TRUE,
                   fillOpacity = 0.5, weight=2, fillColor = "yellow",
                   popup = paste0("MoundID: ", mounds$identifier,
                                  "<br> Height: ", mounds$HeightMax,
                                  "<br> Condition: ", mounds$Condition,
                                  "<br> Last Damage: ", mounds$MostRecentDamageWithin)) %>%
  addLayersControl(
    baseGroups = c("Topo","ESRI Aerial"),
    overlayGroups = c("Mounds"),
    options = layersControlOptions(collapsed = T))


# Mounds with Icon
MoundIcon <- makeIcon(iconUrl = "data/Mound.png", 20, 20)

leaflet() %>%
  addTiles() %>%
  addProviderTiles("Esri.WorldTopoMap", group = "Topo") %>%
  addProviderTiles("Esri.WorldImagery", group = "ESRI Aerial") %>%
  addMarkers(data=mounds, group="Mounds", icon = MoundIcon,  
             popup = paste0("MoundID: ", mounds$identifier,
                            "<br> Height: ", mounds$HeightMax,
                            "<br> Condition: ", mounds$Condition,
                            "<br> Last Damage: ", mounds$MostRecentDamageWithin)) %>%
  
  addLayersControl(
    baseGroups = c("Topo","ESRI Aerial"),
    overlayGroups = c("Mounds"),
    options = layersControlOptions(collapsed = T))

