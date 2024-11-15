
library(tidyverse)
library(sf)



##############################################
## 
##  Level 2 - Integration of data and indicators into CSquare spatial framework 
##
###############################################

owf_turb =  st_read(dsn = "./data/smmart_l1/smmart_l1_coastal_health_wk.gpkg", layer = "l1_ha_offshorewind_pylons")
