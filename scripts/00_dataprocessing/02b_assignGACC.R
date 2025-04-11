

#read in gacc
gacc<-read_sf("input_data\\National_GACC_Boundaries-shp\\National_GACC_Current_20200226.shp")
gacc_proj<-st_transform(gacc,5070)
gacc_buf<-st_buffer(gacc_proj,0)

ica_samp<-read.csv("data\\sample_subset.csv")
ica_samp_select<-ica_samp[!is.na(ica_samp$POO_LATITUDE),c("INCIDENT_ID","POO_LATITUDE",'POO_LONGITUDE')]

inc_poo = st_as_sf(ica_samp_select, coords = c("POO_LONGITUDE","POO_LATITUDE"), crs = 4326)

inc_poo_proj<-st_transform(inc_poo,5070)


registerDoParallel(makeCluster(12))
ptm <- proc.time()
print(Sys.time())

incident_ids<-unique(inc_poo_proj$INCIDENT_ID)

#for every burned area mtbs footprint, intersect with surface management 
#write out combined sf object with all intersections
burn_gacc<-foreach(i=incident_ids, .combine = rbind, .packages=c('sf')) %dopar%  {
  
  pnt<-inc_poo_proj[inc_poo_proj$INCIDENT_ID==i,]
  #fp_buf<-st_buffer(fp,0)
  gacc_forburns<-st_intersection(pnt,gacc_buf)#5 miles = 8047 meters
  
}

print(Sys.time())
stopImplicitCluster()
proc.time() - ptm

write.csv(burn_gacc,"data\\gacc_assign.csv")
