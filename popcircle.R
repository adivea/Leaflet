# Calculate global CO2 ratios and display shapes with values
# https://rcarto.github.io/popcircle/index.html
# full git repo available: https://github.com/rcarto/popcircle
# small edits were needed with wb_data(), start_, end_date, 
# calculations of "value" for popcircle via COKT/POP

library(rnaturalearth)
library(sf)
library(tidyverse)

library(wbstats)
library(remotes)
install_github("rCarto/popcircle")
library(popcircle)
library(leaflet)

# Get countries
ctry <- ne_countries(scale = 50, returnclass = "sf")
# We use web mercator (easy display with leaflet)
ctry <- st_transform(ctry, 3857)

# Only keep the largest polygons of multipart polygons for a few countries
# (e.g. display only continental US)
frag_ctry <- c("US", "RU", "FR", "IN", "ES", "NL", "CL", "NZ", "ZA", "AU", "KR")
largest_ring = function(x) {
  x$ids <- 1:nrow(x)
  pols = st_cast(x, "POLYGON", warn = FALSE)
  spl = split(x = pols, f = pols$ids)
  do.call(rbind, (lapply(spl, function(y) y[which.max(st_area(y)),])))
}
st_geometry(ctry[ctry$iso_a2 %in% frag_ctry,]) <-
  st_geometry(largest_ring(ctry[ctry$iso_a2 %in% frag_ctry,]))


# Get and merge data
ctry_pop <- wb_data(indicator = "SP.POP.TOTL", start_date = 2018, end_date = 2018)
data_co2 <- wb_data(indicator = "EN.ATM.CO2E.KT", start_date = 2014, end_date = 2014)
ctry_co2 <- merge(ctry[,"iso_a2"], data_co2, by.x = "iso_a2", by.y = "iso2c" )
ctry_co2 <- ctry_co2 %>% 
  left_join(ctry_pop[,c(2,5)], by = "iso3c")
ctry_co2 <- ctry_co2 %>% 
  mutate(EN.ATM.CO2E.T = EN.ATM.CO2E.KT*100, co2Tpax = EN.ATM.CO2E.T/SP.POP.TOTL)
# Computes circles and polygons
res_co2 <- popcircle(x = ctry_co2, var = "co2Tpax")
circles_co2 <- res_co2$circles
shapes_co2 <- res_co2$shapes
shapes_co2 <- st_transform(shapes_co2, 4326)
circles_co2 <- st_transform(circles_co2, 4326)


# Create labels
shapes_co2$lab <- paste0("<b>", shapes_co2$country, "</b> <br>", 
                         round(shapes_co2$co2Tpax*1000), " Tons per 1000 people")

# Create the interactive visualisation
leaflet(shapes_co2, width=800, height = 750) %>%
  addPolygons(data = circles_co2,  opacity = 1,
              color = "white", weight = 1.5,
              options = list(interactive = FALSE),
              fill = T, fillColor = "#757083",
              fillOpacity = 1, smoothFactor = 0) %>%
  addPolygons(data = shapes_co2,  opacity = .8,
              color = "#88292f",
              weight = 1.5,popup = shapes_co2$lab,
              options = list(clickable = TRUE),
              fill = T, fillColor = "#88292f",
              fillOpacity = .9, smoothFactor = .5)
