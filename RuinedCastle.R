
library(sf)
### RUINED CASTLE prepare data (16 June 2018 download from faims2.fedarch.org)

# Using FAIMS generated shapefile
rc <- st_read("./data/Feature.shp")
nrow(rc)

# Define the *forgotten* crs definition
st_crs(rc) <- st_crs(28356) # defining CRS, which I know to be MGA 56
st_crs(rc)
tail(rc)

# Transform
rc <- st_transform(rc[-257], crs = 4326) # reprojecting into LatLong
head(data.frame(rc)[,1:10])
names(rc)
which(is.na(rc$geometry))

#Using FAIMS csv with coordinates
rcdata <- read.csv("./data/RCFeature.csv", stringsAsFactors = FALSE)
nrow(rcdata)
names(rcdata)
which(is.na(rcdata$Longitude))
rcdata <- st_as_sf(rcdata[-257,],coords = c("Longitude", "Latitude"), crs = 4326)

st_geometry(rcdata)

plot(rcdata$geometry)



####      PLOT RUINED CASTLE


library(leaflet)

leaflet() %>%
  addTiles() %>%
  addProviderTiles("Esri.WorldTopoMap", group = "Topo") %>%
  addProviderTiles("Esri.WorldImagery", group = "ESRI Aerial") %>%
  #addProviderTiles("NASAGIBS.ViirsEarthAtNight2012", group = "Night") %>% 
  #addProviderTiles("CartoDB.Positron", group = "CartoDB") %>%
  #addProviderTiles("OpenStreetMap.Mapnik", group = "OpenStreet")%>%
  addCircleMarkers(data=ropeway, group="Ropeway", radius =1, color = "blue", opacity = 0.5,
                   stroke = TRUE, fillColor = "blue") %>% 
  addCircleMarkers(data=rcdata, radius = 3, opacity = 0.5, color= "black", stroke = TRUE,
                   fillOpacity = 0.5, weight=2, fillColor = "red",
                   popup = paste0("FeatureID: ", rcdata$FeatureID,
                                  "<br> Type: ", rcdata$FeatureType,
                                  "<br> Interpretation: ", rcdata$Interpretation,
                                  "<br> Notes: ", rcdata$Comments)) %>%
  addLayersControl(
    baseGroups = c("Topo","ESRI Aerial", "CartoDB", "OpenStreet", "Night"),
    overlayGroups = c("Features", "Ropeway"),
    options = layersControlOptions(collapsed = T))


# LOADING BMR data tracklog
ropeway <- read.csv("./data/BMRtracklog.csv", stringsAsFactors = FALSE)
head(ropeway)
tail(ropeway)
names(ropeway)
ropeway <- ropeway[ropeway$x>0,]


ropeway <- st_as_sf(ropeway, coords = c("x","y"), crs=4326)
plot(ropeway$geometry)
plot(rc$geometry, col= "red", add=TRUE)



####      PLOT BMR


library(leaflet)

leaflet() %>%
  addTiles() %>%
  addProviderTiles("Esri.WorldTopoMap", group = "Topo") %>%
  addProviderTiles("Esri.WorldImagery", group = "ESRI Aerial") %>%
  #addMarkers(data=rcdata, group="Features", icon = $$$, opacity = 0.5,
  addCircleMarkers(data=rcdata, radius = 1.5, opacity = 0.5, color = "red", stroke = TRUE) %>% 
  addCircleMarkers(data=ropeway, radius = 1, opacity = 0.5, color= "black", stroke = TRUE,
                   fillOpacity = 0.5, weight=2, fillColor = "white") %>%
  
  addLayersControl(
    baseGroups = c("Topo","ESRI Aerial"),
    overlayGroups = c("Features"),
    options = layersControlOptions(collapsed = T))


## how do we add multiple feature layers in Leaflet?
# just by adding rows.


# THIS NIGHT MAP IS NOT WORKING
#http://map1.vis.earthdata.nasa.gov/wmts-webmerc/VIIRS_CityLights_2012/default/{time}/{tilematrixset}{maxZoom}/{z}/{y}/{x}.{format}'