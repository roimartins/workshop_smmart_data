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
