
#this scripts generates the bargraph for figure 1a 
#the map in figure 1a is not included here. It was generated in QGIS using the POO_LATITUDE, POO_LONGITUDE for each incident (where available)
#the incident locations are then color-coded by year following the hex codes listed below for the barchart

##read in the incident table
incidents_raw<-read.csv("data\\ica_jca_data.csv")


count_inc_peryear<- as.data.frame(table(incidents_raw$START_YEAR))



ggplot(count_inc_peryear, aes(x=Var1 , y=Freq, fill=Var1 )) +#fill=variable)) + 
  geom_bar(stat="identity")+
  xlab("Year") + ylab("Count")+
  scale_fill_manual(values=c("#000004", 
                             "#060419", 
                             "#110c32", 
                             "#20114d",
                             "#331067",
                             "#470f77",
                             "#59157e",
                             '#6c1c81',
                             "#7d2381",
                             "#902a81",
                             "#a3307e",
                             "#b63679",
                             "#c93d72",
                             "#da476a",
                             "#ea5562",
                             "#f4675c",
                             "#fa7c5d",
                             "#fd9266",
                             "#fea872",
                             "#febe82",
                             "#fed395",
                             "#fde9a9" )) +
  theme_minimal()+
  theme(legend.position="none",
    axis.text.x = element_text(angle=60, vjust = 0.9, 
                               hjust=1,size=13),
        axis.title.x =element_text(size=14),
        axis.title.y =element_text(size=14),
        axis.text.y = element_text(size=14)
        )

ggsave("analysis_outputs\\fig1a_barplot.jpg",width=6, height=4, units= "in", dpi = 600)
  


