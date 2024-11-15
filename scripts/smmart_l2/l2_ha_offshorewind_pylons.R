
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
  mutate ( csquare0p05 =  getCsquareCode(lon,  lat, 0.05) ) |> 
  mutate ( csquare0p01 =  getCsquareCode(lon,  lat, 0.01) )





#2.2  Get the CSquare grid for the L1 dataset


#2.2.1 Get the CSquare grid that cover all extent of the  features in the L1 dataset


grid = getCsquareGrid(spatial_layer = owf_turb, cell_size = 0.01,  projection = 3035 ) ## Albers European Equal Area projection




#2.2.2 Get only  the CSquare grid that overlap with each  features in the L1 dataset


grid_owf_turb = grid %>% filter ( csquare %in% unique(owf_turb$csquare0p01 ))

str(owf_turb)



#2.3 Create the L2 Data Layer 

##Calculate the L1 dataset derived indicators and aggregate into a C-Square 


L2_ha_offshorewind_pylons  =  owf_turb |> 
  st_drop_geometry() |>
  group_by(csquare0p01, instat, strtyp  ) |>  
  summarise(np = n(),  ##get the number of turbines 
            area_pylons_total = sum ( area,   na.rm = T ), 
            area_pylons_mean = mean ( area,   na.rm = T ), 
            min_bldrad = min(bldrad ,  na.rm = T ), 
            max_bldrad = max(bldrad ,  na.rm = T ), 
            avg_bldrad = mean(bldrad ,  na.rm = T ), 
            min_naclle = min(naclle ,  na.rm = T ), 
            max_naclle = max(naclle ,  na.rm = T ), 
            avg_naclle = mean(naclle ,  na.rm = T ) ,
            min_clrhgt = min(clrhgt ,  na.rm = T ), 
            max_clrhgt = max(clrhgt ,  na.rm = T ), 
            avg_clrhgt = mean(clrhgt ,  na.rm = T )) 




L2_ha_offshorewind_pylons =  grid_owf_turb  |> inner_join( L2_ha_offshorewind_pylons  , join_by(csquare  ==  csquare0p01 ) ) 


L2_ha_offshorewind_pylons = L2_ha_offshorewind_pylons |>  mutate ( area_pylons_ratio  = area_pylons_total / grid_cell_area   )






## Save the L2_ha_offshorewind_pylons SMMART product

 
st_write( obj =  L2_ha_offshorewind_pylons,  dsn =    "./data/smmart_l2/smmart_l2.gpkg", layer = "L2_ha_offshorewind_pylons", append = FALSE)

