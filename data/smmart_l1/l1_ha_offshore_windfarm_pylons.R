library(tidyverse)
library(sf)


##############################################
## 
##  Level 1 - Source data refinement
##
###############################################


##1.1 Data load  ###################################################################
## Connect to Spatial Hub Portal to obtain the pylons data


owf_turb =  st_read(dsn = "./data/smmart_l1/smmart_l1_coastal_health_wk.gpkg", layer = "l1_ha_offshorewind_pylons")


##1.2 Data Refinement   ###################################################################



##  Assign a buffer to each turbine location related to the radius of the turbine size. ###
##  Average radio of the turbine is taken from a publication: 


# Buffer distance determined by values in Foden et al. 2011
r = 15 ## meters
a = pi*r^2 ## m^2


owf_turb =  owf_turb |>
  mutate(rad = r , area = a) |> 
  mutate ( lon = st_coordinates(owf_turb, )[,1 ], lat = st_coordinates(owf_turb)[,2] )
