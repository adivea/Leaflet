#Leaflet

This repository contains an R project with several R scripts that illustrate how R users can engage with spatial data through Leaflet package. 
- The Backgrounds.R illustrates how one might load background tiles (raster background maps). set zoom and view, manually create pop-up locations, and display existing Lat Long data, and save the entire map as a html interactive package for online dissemintation.
- The FAIMSmodules.R illustrates how one can download raw data from Github/Internet, clean up and validate it, and display it in a map. 
- The Mounds.R script shows how you can take a spreadsheet with X, Y data, convert these into LatLong and visualize them on the basis of attribute data or self-made icons with complex labels on different kinds of background tiles.
- The Hotsprings.R is a script by Ryan Peek of UC Davis (https://ryanpeek.github.io/2017-08-03-converting-XY-data-with-sf-package/) which shows how you can download structured LatLong data from the internet and plot it in R. This script uses the sf package to make LatLong data into a geometry for use in additional spatial analysis. SF package is also used to reproject the data from Albers EPSG 32610 to Mercator EPSG 4326 for display in Leaflet.  
