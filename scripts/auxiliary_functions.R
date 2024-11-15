getCsquareCode <- function(lon,lat,degrees){
  
  if(length(lon) != length(lat)) stop("length of longitude not equal to length of latitude")
  if(!degrees %in% c(10,5,1,0.5,0.1,0.05,0.01)) stop("degrees specified not in range: c(10,5,1,0.5,0.1,0.05,0.01)")
  
  dims <- length(lon)
  
  quadrants <- array(NA,dim=c(4,6,dims),dimnames=list(c("globalQuadrant","intmQuadrant1","intmQuadrant2","intmQuadrant3"),c("quadrantDigit","latDigit","lonDigit","latRemain","lonRemain","code"),seq(1,dims,1)))
  
  quadrants["globalQuadrant","quadrantDigit",] <- 4-(((2*floor(1+(lon/200)))-1)*((2*floor(1+(lat/200)))+1))
  quadrants["globalQuadrant","latDigit",]      <- floor(abs(lat)/10)
  quadrants["globalQuadrant","lonDigit",]      <- floor(abs(lon)/10)
  quadrants["globalQuadrant","latRemain",]     <- round(abs(lat)-(quadrants["globalQuadrant","latDigit",]*10),7)
  quadrants["globalQuadrant","lonRemain",]     <- round(abs(lon)-(quadrants["globalQuadrant","lonDigit",]*10),7)
  quadrants["globalQuadrant","code",]          <- quadrants["globalQuadrant","quadrantDigit",]*1000+quadrants["globalQuadrant","latDigit",]*100+quadrants["globalQuadrant","lonDigit",]
  
  quadrants["intmQuadrant1","quadrantDigit",]  <- (2*floor(quadrants["globalQuadrant","latRemain",]*0.2))+floor(quadrants["globalQuadrant","lonRemain",]*0.2)+1
  quadrants["intmQuadrant1","latDigit",]       <- floor(quadrants["globalQuadrant","latRemain",])
  quadrants["intmQuadrant1","lonDigit",]       <- floor(quadrants["globalQuadrant","lonRemain",])
  quadrants["intmQuadrant1","latRemain",]      <- round((quadrants["globalQuadrant","latRemain",]-quadrants["intmQuadrant1","latDigit",])*10,7)
  quadrants["intmQuadrant1","lonRemain",]      <- round((quadrants["globalQuadrant","lonRemain",]-quadrants["intmQuadrant1","lonDigit",])*10,7)
  quadrants["intmQuadrant1","code",]           <- quadrants["intmQuadrant1","quadrantDigit",]*100+quadrants["intmQuadrant1","latDigit",]*10+quadrants["intmQuadrant1","lonDigit",]
  
  quadrants["intmQuadrant2","quadrantDigit",]  <- (2*floor(quadrants["intmQuadrant1","latRemain",]*0.2))+floor(quadrants["intmQuadrant1","lonRemain",]*0.2)+1
  quadrants["intmQuadrant2","latDigit",]       <- floor(quadrants["intmQuadrant1","latRemain",])
  quadrants["intmQuadrant2","lonDigit",]       <- floor(quadrants["intmQuadrant1","lonRemain",])
  quadrants["intmQuadrant2","latRemain",]      <- round((quadrants["intmQuadrant1","latRemain",]-quadrants["intmQuadrant2","latDigit",])*10,7)
  quadrants["intmQuadrant2","lonRemain",]      <- round((quadrants["intmQuadrant1","lonRemain",]-quadrants["intmQuadrant2","lonDigit",])*10,7)
  quadrants["intmQuadrant2","code",]           <- quadrants["intmQuadrant2","quadrantDigit",]*100+quadrants["intmQuadrant2","latDigit",]*10+quadrants["intmQuadrant2","lonDigit",]
  
  quadrants["intmQuadrant3","quadrantDigit",]  <- (2*floor(quadrants["intmQuadrant2","latRemain",]*0.2))+floor(quadrants["intmQuadrant2","lonRemain",]*0.2)+1
  quadrants["intmQuadrant3","latDigit",]       <- floor(quadrants["intmQuadrant2","latRemain",])
  quadrants["intmQuadrant3","lonDigit",]       <- floor(quadrants["intmQuadrant2","lonRemain",])
  quadrants["intmQuadrant3","latRemain",]      <- round((quadrants["intmQuadrant2","latRemain",]-quadrants["intmQuadrant3","latDigit",])*10,7)
  quadrants["intmQuadrant3","lonRemain",]      <- round((quadrants["intmQuadrant2","lonRemain",]-quadrants["intmQuadrant3","lonDigit",])*10,7)
  quadrants["intmQuadrant3","code",]           <- quadrants["intmQuadrant3","quadrantDigit",]*100+quadrants["intmQuadrant3","latDigit",]*10+quadrants["intmQuadrant3","lonDigit",]
  
  if(degrees == 10)   CSquareCodes  <- quadrants["globalQuadrant","code",]
  if(degrees == 5)    CSquareCodes  <- paste(quadrants["globalQuadrant","code",],":",quadrants["intmQuadrant1","quadrantDigit",],sep="")
  if(degrees == 1)    CSquareCodes  <- paste(quadrants["globalQuadrant","code",],":",quadrants["intmQuadrant1","code",],sep="")
  if(degrees == 0.5)  CSquareCodes  <- paste(quadrants["globalQuadrant","code",],":",quadrants["intmQuadrant1","code",],":",quadrants["intmQuadrant2","quadrantDigit",],sep="")
  if(degrees == 0.1)  CSquareCodes  <- paste(quadrants["globalQuadrant","code",],":",quadrants["intmQuadrant1","code",],":",quadrants["intmQuadrant2","code",],sep="")
  if(degrees == 0.05) CSquareCodes  <- paste(quadrants["globalQuadrant","code",],":",quadrants["intmQuadrant1","code",],":",quadrants["intmQuadrant2","code",],":",quadrants["intmQuadrant3","quadrantDigit",],sep="")
  if(degrees == 0.01) CSquareCodes  <- paste(quadrants["globalQuadrant","code",],":",quadrants["intmQuadrant1","code",],":",quadrants["intmQuadrant2","code",],":",quadrants["intmQuadrant3","code",],sep="")
  
  return(CSquareCodes)}




CSquare2LonLat <- function(csqr,degrees){
  
  ra          <- 1e-6 #Artificial number to add for rounding of 5'ves (round(0.5) = 0, but in Excel (where conversion comes from, it is 1)
  chars       <- an(nchar(csqr))
  tensqd      <- an(substr(csqr,1,1))+ra;      gqlat     <- (round(abs(tensqd-4)*2/10)*10/5)-1
  tenslatd    <- an(substr(csqr,2,2))+ra;      gqlon     <- (2*round(tensqd/10)-1)*-1
  tenslond    <- an(substr(csqr,3,4))+ra
  unitsqd     <- an(substr(csqr,6,6))+ra;      iqulat    <- round(unitsqd*2/10)
  unitslatd   <- an(substr(csqr,7,7))+ra;      iqulon    <- (round((unitsqd-1)/2,1) - floor((unitsqd-1)/2))*2
  unitslond   <- an(substr(csqr,8,8))+ra
  tenthsqd    <- an(substr(csqr,10,10))+ra;    iqtlat    <- round(tenthsqd*2/10)
  tenthslatd  <- an(substr(csqr,11,11))+ra;    iqtlon    <- (round((tenthsqd-1)/2,1) - floor((tenthsqd-1)/2))*2
  tenthslond  <- an(substr(csqr,12,12))+ra
  hundqd      <- an(substr(csqr,14,14))+ra;    iqhlat    <- round(hundqd*2/10)
  hundlatd    <- an(substr(csqr,15,15))+ra;    iqhlon    <- (round((hundqd-1)/2,1) - floor((hundqd-1)/2))*2
  hundlond    <- an(substr(csqr,16,16))+ra
  reso        <- 10^(1-floor((chars-4)/4))-((round((chars-4)/4,1)-floor((chars-4)/4))*10^(1-floor((chars-4)/4)))
  
  if(degrees < reso[1]) stop("Returning degrees is smaller than format of C-square")
  if(degrees == 10){   
    lat <- ((tenslatd*10)+5)*gqlat-ra                              
    lon <- ((tenslond*10)+5)*gqlon-ra              
  }
  if(degrees == 5){    
    lat <- ((tenslatd*10)+(iqulat*5)+2.5)*gqlat-ra
    lon <- ((tenslond*10)+(iqulon*5)+2.5)*gqlon-ra 
  }
  if(degrees == 1){    
    lat <- ((tenslatd*10)+ unitslatd+0.5)*gqlat-ra
    lon <- ((tenslond*10)+ unitslond+0.5)*gqlon-ra 
  }
  if(degrees == 0.5){  
    lat <- ((tenslatd*10)+ unitslatd + (iqtlat*0.5)+0.25)*gqlat-ra
    lon <- ((tenslond*10)+ unitslond + (iqtlon*0.5)+0.25)*gqlon-ra
  }         
  if(degrees == 0.1){  
    lat <- ((tenslatd*10)+ unitslatd + (tenthslatd*0.1)+0.05)*gqlat-ra
    lon <- ((tenslond*10)+ unitslond + (tenthslond*0.1)+0.05)*gqlon-ra
  }
  if(degrees == 0.05){ 
    lat <- ((tenslatd*10)+ unitslatd + (tenthslatd*0.1)+(iqhlat*0.05)+0.025)*gqlat-ra
    lon <- ((tenslond*10)+ unitslond + (tenthslond*0.1)+(iqhlon*0.05)+0.025)*gqlon-ra
  }
  if(degrees == 0.01){ 
    lat <- ((tenslatd*10)+ unitslatd + (tenthslatd*0.1)+(hundlatd*0.01)+0.005)*gqlat-ra
    lon <- ((tenslond*10)+ unitslond + (tenthslond*0.1)+(hundlond*0.01)+0.005)*gqlon-ra
  }
  return(data.frame(SI_LATI=lat,SI_LONG=lon))}


################################################ getCsquareGrid  #############################################

getCsquareGrid  <- function ( spatial_layer, csquare_code = FALSE, csquare_field = NULL,  cell_size = 0.05, projection = 4326 ) {
  
  
  if ( csquare_code == FALSE )  {
    ## Get the layer bounding box
    
    bbox = spatial_layer |> sf::st_bbox()  |>  sf::st_as_sfc()  |>
      sf::st_sf( id  = 1, label = 'bbox' )  |>
      sf::st_transform(4326)
    
    
    
    ## Create the grid and assign the CSquare labels to each cell
    
    offset = sf::st_coordinates(bbox)   |>   as.data.frame() |> slice(1) |>
      mutate ( western_eastern = sign (X), northern_southern = sign(Y) ) |>
      mutate ( x = floor ( X) , y = floor(Y) )
    
    
    gridp = sf::st_make_grid(bbox, cellsize = cell_size , crs = 4326  ,
                             offset =  c(offset$x  , offset$y   ) )
    gridp = sf::st_sf(  gridp  ) |> dplyr::rename(geom = gridp)
    
    centroid_coordinates = gridp |> sf::st_centroid() |> sf::st_coordinates()  |>  as.data.frame()
    csquare_label = getCsquareCode(  lon = centroid_coordinates$X, lat = centroid_coordinates$Y, degrees = cell_size)
    
    csquare_grid  =   dplyr::bind_cols(gridp, centroid_coordinates, csquare_label)|> dplyr::rename(lon = X, lat = Y, csquare = 3)
    
    csquare_grid =  csquare_grid |>
      st_transform(projection) |>
      mutate ( area_kmsq = units::set_units( st_area(geom) , "km^2")  ) |>
      st_transform(4326)
    
    
    
  } else  {
    
    
    
    
    csquare_cent = getCsquareCentroid(spatial_layer , csquare_field , cell_size = cell_size)
    
    matrix = csquare_cent  |>
      mutate ( lat_max = csquare_cent$latitude + cell_size   ,
               lat_min = csquare_cent$latitude - cell_size   ,
               lon_max = csquare_cent$latitude + cell_size   ,
               lon_min = csquare_cent$latitude - cell_size    )
    
    csquare_cent_geom = NULL
    
    for (csquare_sel in unique( matrix$csquare)) {
      #csquare_sel = '1500:100:104:4'
      
      r1 = matrix |> filter(csquare == csquare_sel)
      
      m  =    rbind(c(r1$lat_max,r1$ lon_min) ,
                    c (r1$lat_max,r1$lon_max  ) ,
                    c(r1$lat_min, r1$lon_max  ),
                    c( r1$lat_min, r1$lon_min),
                    c( r1$lat_max,r1$ lon_min)  )
      
      poly = st_sfc (st_polygon( list ( m))  )
      
      
      row =   st_sf(  csquare_cent |>    filter(csquare == csquare_sel),   geom = st_sfc(poly )  ,  crs = st_crs(4326)  )
      
      
      csquare_cent_geom =  csquare_cent_geom |> rbind(row )
    }
    
    
    
    csquare_grid = csquare_cent_geom
    
  }
  
  return (csquare_grid)
  
}
