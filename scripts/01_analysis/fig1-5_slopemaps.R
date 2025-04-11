
#this script generates the maps and legends for figures 2-5 and shapefiles
#outputs produces here were then used to color match and create higher quality map layouts in QGIS
#the top 5% incident locations are not included in the output maps created here - see fig2-5c_bargraphs.R .csv outputs for those incident locations



gacc_var_slopes<- read.csv("analysis_outputs//table_a3.csv")


#read in gacc shapefile
shape_gaccs<-read_sf("input_data\\National_GACC_Boundaries-shp\\National_GACC_Current_20200226.shp")

shape_of_gaccs<-st_transform(shape_gaccs,2163)



#attach the slope information to the gacc shapefile
merged_gacc<-merge(shape_of_gaccs,gacc_var_slopes,by.x="GACCAbbrev",by.y="GACC")

#create individual shapefiles to make separate maps
#not necessary, but quick and dirty for working 
grouped_shapefile1<-merged_gacc %>% 
  split(f = as.factor(.$variable))

grouped_shapefile<-grouped_shapefile1[c(1,2,3,4,5)]


plot_names<-c("Engaged Jurisdictions","Final Acres","Incident Count","National Preparedness Level - Days at 4 & 5", "Structures")
              
 

var_group_slopes <- gacc_var_slopes %>% group_by(variable) %>% summarise(max_slope_abs=max(slope),min_slope_abs=abs(min(slope)))


var_group_slopes$halfrange_touse <- c(0.006, 0.01 ,0.02,0,0)



var_group_slopes$top1 <- (var_group_slopes$halfrange_touse/100)*2.5
var_group_slopes$top2 <- var_group_slopes$top1+(var_group_slopes$halfrange_touse/100)*10
var_group_slopes$top3 <- var_group_slopes$top2+(var_group_slopes$halfrange_touse/100)*15
var_group_slopes$top4 <- var_group_slopes$top3+(var_group_slopes$halfrange_touse/100)*15


var_group_slopes$bottom1 <- var_group_slopes$top1*-1
var_group_slopes$bottom2 <- var_group_slopes$top2*-1
var_group_slopes$bottom3 <- var_group_slopes$top3*-1
var_group_slopes$bottom4 <- var_group_slopes$top4*-1

figure<-c("fig2a","fig3a","fig1b","fig4a","fig5a")

#this loop iterates through variables and produce GACC maps of slope values for lower 48 states, AK, HI, + legend 

for (i in 1:length(grouped_shapefile)){

  var_shp<-grouped_shapefile[[i]]
  var_name<-var_shp$variable[1]
  fig<-figure[i]

  var_shp$slope_num<-as.numeric(var_shp$slope)


  val <- st_make_valid(var_shp)

  cropped<- st_crop(val, xmin = -2000000, xmax = 3000000 , ymin = -2500000, ymax = 1000000)
  cropped_ak<- st_crop(val, xmin = -6000000, xmax = -1000000 , ymin = 1000000, ymax = 4000000)
  

  cropped_hi<-st_crop(val, xmin = -6250000, xmax = -3000000 , ymin = -2500000, ymax = 1000000)

  limit <- max(abs(cropped$slope_num)) * c(-1, 1)
  print(limit)
  print(var_name)
  print(max(cropped$slope_num))
  print(min(cropped$slope_num))



  plot.new()

  p <- ggplot() +
    geom_sf(data = cropped,aes(fill=slope_num))+
    scale_fill_distiller(type = "div",limit=limit,name=plot_names[i],palette = "BrBG",direction=-1)+
    theme_void()+
    theme(legend.position="none")


  p



  ggsave(paste0(fig,".png"),p,png(),"analysis_outputs\\maps\\",bg="transparent")
  dev.off()

  plot.new()


  p_ak <- ggplot() +
    geom_sf(data = cropped_ak,aes(fill=slope_num))+
    scale_fill_distiller(type = "div",limit=limit,name=plot_names[i],palette = "BrBG",direction=-1)+
    theme_void()+
    theme(legend.position="none")


  p_ak



  ggsave(paste0(fig,"_ak.png"),p_ak,png(),"analysis_outputs\\maps\\",bg="transparent",dpi = 900)
  dev.off()

  plot.new()
  p_hi <- ggplot() +
    geom_sf(data = cropped_hi,aes(fill=slope_num))+
    scale_fill_distiller(type = "div",limit=limit,name=plot_names[i],palette = "BrBG",direction=-1)+
    theme_void()+
    theme(legend.position="none")
 
  p_hi



  ggsave(paste0(fig,"_hi.png"),p_hi,png(),"analysis_outputs\\maps\\",bg="transparent",dpi = 900)
  dev.off()


  p2<-ggplot() +
    geom_sf(data = cropped,aes(fill=slope_num))+
    scale_fill_distiller(type = "div",limit=limit,palette = "BrBG",direction=-1)+
    theme_void()+
    theme(legend.title= element_blank(),
          legend.key.height = unit(2, 'cm'),
          legend.key.width = unit(0.75, 'cm'),
          legend.text = element_text(size=14))

  legend <- get_legend(
    p2 
  )

  plot.new()
  plot(legend)

  ggsave(paste0(fig,"_leg.png"),legend,png(),"analysis_outputs\\maps\\",bg="transparent",dpi = 900)

  dev.off()
  
  delfiles <- dir(pattern="Rplot*")
  file.remove(delfiles)
  
}



#make separate shapefile names
shapefile_names<-names(grouped_shapefile)

#write out GACC shapefile with slope values for each variable
for (i in 1:length(grouped_shapefile)){
  grouped_shapefile[[i]]$slope_num<-as.numeric(grouped_shapefile[[i]]$slope)
  st_write(grouped_shapefile[[i]],paste0("analysis_outputs\\maps\\fig1-5_shapefiles\\",shapefile_names[i],".shp"),append=TRUE)
}



dev.off()


delfiles <- dir(pattern="Rplot*")
file.remove(delfiles)





































