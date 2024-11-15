
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




#2.2  Get the CSquare grid for the L1 dataset


#2.2.1 Get the CSquare grid that cover all extent of the  features in the L1 dataset


grid = getCsquareGrid(spatial_layer = owf_turb, cell_size = 0.05,  projection = 3035 ) ## Albers European Equal Area projection




#2.2.2 Get only  the CSquare grid that overlap with each  features in the L1 dataset


grid_owf_turb = grid %>% filter ( csquare %in% unique(owf_turb$csquare ))

str(owf_turb)


## Save the L2_ha_offshorewind_pylons SMMART product

 
st_write( obj =  grid_owf_turb,  dsn =    "./data/smmart_l2/smmart_l2.gpkg", layer = "L2_ha_offshorewind_pylons", append = FALSE)




