
library(tidyverse)
library(sf)
source("./scripts/auxiliary_functions.R")



##############################################
## 
##  Level 2 - Integration of data and indicators into CSquare spatial framework 
##
###############################################

owf_turb =  st_read(dsn = "./data/smmart_l1/smmart_l1_coastal_health_wk.gpkg", layer = "l1_ha_offshorewind_pylons")



## Topology of L2 integration : Point ( pressure /receptor ) to polygon  ( CSquare)

#2.1 Identify CSquare geocode for each feature 

owf_turb = owf_turb |> 
  mutate ( csquare =  getCsquareCode(lon,  lat, 0.05) ) |> 
  mutate ( csquare0p01 =  getCsquareCode(lon,  lat, 0.01) )
