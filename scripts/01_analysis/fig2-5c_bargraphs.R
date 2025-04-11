
#this script produces the top5% barplots in figures 2-5
#it also write out .csvs for the locations of the top 5% incidents for each variable
#these .csvs (using POO_LATITUDE, POO_LONGITUDE, and START_YEAR.x) were used to overlay and color the incident locations in QGIS


##read in the incident table
incidents<-read.csv("data\\ica_jca_data.csv")

##subsetting down to the top 5% of incidents for each variable generally does not have missing data, except for days NPL 4&5, so I have merged a table with yeras that would be 0, except for all jurisdictions (same approach as GACCs)


incidents$VALS_AT_RISK<-incidents$STR_DAMAGED_TOTAL+incidents$STR_DESTROYED_TOTAL+incidents$STR_THREATENED_MAX
incidents["VALS_AT_RISK"][is.na(incidents["VALS_AT_RISK"])] <- 0
incidents$NPL_DAYS_4_5<-incidents$Days_PL4+incidents$Days_PL5


#make top 5% tables

#engaged jurisdictions
top_5perc_jur <- incidents %>%
  filter(alljur_engag_cnt >= quantile(alljur_engag_cnt, probs = 0.95, na.rm = TRUE))

top_5percjur_loc <- top_5perc_jur[,c("INCIDENT_ID","START_YEAR.x","POO_LATITUDE","POO_LONGITUDE")]

write.csv(top_5percjur_loc,"analysis_outputs\\figure2a_top5perc_pntlocations.csv")


#final acres
top_5perc_acre <- incidents %>%
  filter(FINAL_ACRES >= quantile(FINAL_ACRES, probs = 0.95, na.rm = TRUE))


top_5percacre_loc <- top_5perc_acre[,c("INCIDENT_ID","START_YEAR.x","POO_LATITUDE","POO_LONGITUDE")]

write.csv(top_5percacre_loc,"analysis_outputs\\figure3a_top5perc_pntlocations.csv")


#npl days
top_5perc_npl <- incidents %>%
  filter( NPL_DAYS_4_5>= quantile(NPL_DAYS_4_5, probs = 0.95, na.rm = TRUE))


top_5percnpl_loc <- top_5perc_npl[,c("INCIDENT_ID","START_YEAR.x","POO_LATITUDE","POO_LONGITUDE")]

write.csv(top_5percnpl_loc,"analysis_outputs//figure4a_top5perc_pntlocations.csv")

#values at risk
top_5perc_vals <- incidents %>%
  filter( VALS_AT_RISK>= quantile(VALS_AT_RISK, probs = 0.95, na.rm = TRUE))


top_5percvals_loc <- top_5perc_vals[,c("INCIDENT_ID","START_YEAR.x","POO_LATITUDE","POO_LONGITUDE")]

write.csv(top_5perc_vals,"analysis_outputs//figure5a_top5perc_pntlocations.csv")



tables<-list(top_5percjur_loc,top_5percacre_loc,top_5percnpl_loc,top_5percvals_loc)

columns <- c("alljur_engag_cnt","final_acres","NPL_DAYS_4_5","VALS_AT_RISK")
titles <- c("Top 5%: Engaged Jurisdictions","Top 5%: Final Acres","Top 5%: Days at NPL 4 & 5", "Top 5%: Values at Risk")
y_axes <- c("Count of Jurisdictions","Acres","Days", "Values")
figure<-c("figure2c","figure3c","figure4c","figure5c")



count=0

for (i in tables){


count=count+1
df <- i
var_name <- columns[count]
y_axis <- y_axes[count]
title <- titles[count]
fig <- figure[count]

#df <- tables[[3]]
print(var_name)
print(table(df$START_YEAR.x))
df_counts <- as.data.frame(table(df$START_YEAR.x))
colnames(df_counts) <- c("year","count")


allyears0 <- as.data.frame(cbind(year=as.character(seq(1999,2020,1))))#,count=rep(0,length(1999:2020))))
df_counts$year_char<-as.character(df_counts$year)
df<-merge(df_counts,allyears0,by.x="year_char",by.y="year",all.y=TRUE)
df$count[is.na(df$count)] <- 0

print(df)


# Basic barplot

  ggplot(data=df, aes(x=year_char, y=count,fill=year_char)) +
  geom_bar(stat="identity",colour="black")+
    xlab("Year")+
    ylab("Count")+
    theme_minimal()+
    scale_fill_manual(values=c("#000000", 
                               "#000000", 
                               "#000000", 
                               "#000000",
                               "#000000",
                               "#52504f",
                               "#52504f",
                               "#52504f",
                               '#52504f',
                               "#52504f",
                               "#52504f",
                               "#adaba7",
                               "#adaba7",
                               "#adaba7",
                               "#adaba7",
                               "#adaba7",
                               "#adaba7",
                               "#ffffff",
                               "#ffffff",
                               "#ffffff",
                               "#ffffff",
                               "#ffffff"))+
    theme_minimal()+
    theme(legend.position="none",
          axis.text.x = element_text(angle=60, vjust = 0.9, 
                                     hjust=1,size=13),
          axis.title.x =element_text(size=14),
          axis.title.y =element_text(size=14),
          axis.text.y = element_text(size=14)
    )
  
#ggsave(paste0("analysis_outputs//top5_barplot",var_name,".jpg"),width=6, height=4, units= "in", dpi = 900)
ggsave(paste0("analysis_outputs//",fig,".jpg"),width=6, height=4, units= "in", dpi = 900)
  
}



