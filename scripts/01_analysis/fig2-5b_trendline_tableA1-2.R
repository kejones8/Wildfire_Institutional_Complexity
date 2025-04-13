#this script generates the scatterplots and thielsen trendlines and 'confidence' metrics for figures 2-5 & tables A1-2



#read in up to date incident table
incidents<-read.csv("data\\ica_jca_data.csv")


#creating variables that aren't already in the incident table
incidents$VALS_AT_RISK<-incidents$STR_DAMAGED_TOTAL+incidents$STR_DESTROYED_TOTAL+incidents$STR_THREATENED_MAX
incidents["VALS_AT_RISK"][is.na(incidents["VALS_AT_RISK"])] <- 0
incidents$NPL_DAYS_4_5<-incidents$Days_PL4+incidents$Days_PL5
incidents$FINAL_SQKM <- incidents$FINAL_ACRES * 0.004


var_names<-c("FINAL_SQKM","ALLJUR_ENGAG_CNT","VALS_AT_RISK","NPL_DAYS_4_5")

#make all colnames uppercase
names(incidents)<-toupper(names(incidents))


incidents_subset<-incidents[,c("INCIDENT_ID","START_YEAR.X",var_names)]



table_list<-list(incidents_subset)

#create the dataframe we'll store all of the table values in 
samp_var_slopes<-data.frame(matrix(NA, nrow = 5, ncol = 10))
colnames(samp_var_slopes)<-c("n","variable","slope","mean_abs_error","mean","max","min","std_dev","slope_90CI_upper","slope_90CI_lower")
#axes values & file names to iterate through
figure<-c("fig2b_trendline","fig3b_trendline","fig4b_trendline","fig5b_trendline")
yax_names<-c("Square Kilometers", "Engaged Jurisdictions","Number of Structures", "Days")

titles<-c("Trend of Average Final Square Kilometers : 1999-2020", "Trend of Engaged Jurisdictions : 1999-2020","Trend of Structures Damaged, Destroyed and Threatened : 1999-2020", "Trend of National Preparedness Level - Days at 4 & 5 : 1999-2020")



count<-0
#this first loop is a relic from older code structure
#NOTE: incident_subset is just renamed to df
for (i in 1:length(table_list)){
  df<-incidents_subset
  
  
  #step through the variables
  for (x in 1:length(var_names)) {
    
    
    count<-count+1

    
    #specify variable
    var_name<-var_names[x]
    axis_name<-yax_names[x]
    title<-titles[x]
    fig<-figure[x]
    

    df_uni_bleh<-unique(df[,c("INCIDENT_ID","START_YEAR.X",var_name)])
    df_uni<-df_uni_bleh[complete.cases(df_uni_bleh),]#do complete cases
    num<-nrow(df_uni)
    
    #take average of variables by year
    mean_table<- df_uni %>% group_by(START_YEAR.X) %>% summarise(mean=mean(.data[[var_name]]))
    
    
    options(scipen=999)
    
    
    mean_table<-as.data.frame(mean_table)

    
    mean_table$date<-as.POSIXct(paste0(mean_table$START_YEAR.X,"-01-01"))
    mean<-mean_table[['mean']]
    yr<-mean_table[['START_YEAR.X']]

    
    ploop<-openair::TheilSen(mean_table,pollutant="mean",date.format = "%Y",autocor=FALSE,shade="white",data.col="black",alpha=0.1,text.col="transparent",xlab = "Year",trend = list(lty = c(1, 5), lwd = c(2, 1), col = c("black", "blue")),plot=TRUE)#autocor=TRUE
    

    
    fit<-mblm(mean ~ yr)
    fit_fordw<-lm(mean~yr)
    mean_detrend <- as.numeric(diff(mean_table$mean))
    fit_detrend <- lm(mean_detrend ~ yr[1:21])
    
    print(var_name)
    print(durbinWatsonTest(fit_fordw))
    print(durbinWatsonTest(fit_detrend))
    

    
    summary(fit)
    

    slope <- as.numeric(coef(fit)[2])
    slope <- round(ploop$data$main.data$slope[1],2)
    res <- residuals(fit)

  
    mae <- round(median(abs(res)),2)

    
    df_uni$year <- as.factor(df_uni$START_YEAR.X)
    
     avg<-round(mean(df_uni[,var_name],na.rm=TRUE),2)
     max<-round(max(df_uni[,var_name],na.rm=TRUE),2)
     min<-round(min(df_uni[,var_name],na.rm=TRUE),2)
     std_dev<-round(sd(df_uni[,var_name],na.rm=TRUE),2)

    
    int_up_70<-ploop$data$res2$intercept.upper[1]
    int_low_70<-ploop$data$res2$intercept.lower[1]
    
    slope_up <- round(ploop$data$res2$upper[1],2)
    slope_low <- round(ploop$data$res2$lower[1],2)
      

    int <- ploop$data$res2$intercept-(slope*1970)
    
    int_up <- int_up_70-(slope_up*1970)
   
    int_low <- int_low_70-(slope_low*1970)
   

    

    p <- ggplot(data=mean_table,aes(x=yr,y=mean))+

      geom_abline(intercept=int, slope=slope, col="black",linewidth=1.3)+
      geom_abline(intercept=int_up, slope=slope_up, col="blue",linewidth=0.75,lty=2,alpha=0.5)+
      geom_abline(intercept=int_low, slope=slope_low, col="blue",linewidth=0.75,lty=2,alpha=0.5)+
      geom_point(cex=2.75)+
      

      xlab("Year")+
      ylab(axis_name)+
      theme_classic()+
      theme(legend.position="none",
            axis.text.x = element_text(angle=45, vjust = 0.9,
                                       hjust=1,size=16),
            axis.title.x =element_text(size=20),
            axis.title.y =element_text(size=20),
            axis.text.y = element_text(size=20),
            rect = element_rect(fill = "transparent"),

            plot.background = element_rect(fill='white', color=NA),
            panel.background = element_rect(fill='transparent', color=NA)
      )

    print(p)

    ggsave(paste0("analysis_outputs//",fig,".jpg"),width=10, height=8, units= "in", dpi = 900)
    
    new_row<-c(num,var_name,slope,mae,avg,max,min,std_dev,slope_up,slope_low)

    #append it
    samp_var_slopes[count,]<-new_row
    
    
  }
  
}

#handle incident counts separately - no averaging within yeras

inc_counts_peryear<-incidents %>% group_by(START_YEAR.X) %>% summarise(n=n())
num<-nrow(incidents)

n <- inc_counts_peryear[['n']]

mean_table$n<-n
yr <- inc_counts_peryear[['START_YEAR.X']]


ploop<-openair::TheilSen(mean_table,pollutant="n",date.format = "%Y",autocor=FALSE,shade="white",data.col="black",alpha=0.1,text.col="transparent",xlab = "Year",trend = list(lty = c(1, 5), lwd = c(2, 1), col = c("black", "blue")),plot=TRUE)#autocor=TRUE

fit<-mblm(n ~ yr)

fit_fordw <- lm (n~yr)

mean_detrend <- as.numeric(diff(mean_table$n))
fit_detrend <- lm(mean_detrend ~ yr[1:21])

print("INC_COUNT")
print(durbinWatsonTest(fit_fordw))
print(durbinWatsonTest(fit_detrend))



int_up_70<-ploop$data$res2$intercept.upper[1]
int_low_70<-ploop$data$res2$intercept.lower[1]

slope_up <- round(ploop$data$res2$upper[1],2)
slope_low <- round(ploop$data$res2$lower[1],2)

slope <- round(ploop$data$main.data$slope[1],2)
int <- ploop$data$res2$intercept-(slope*1970)

int_up <- int_up_70-(slope_up*1970)

int_low <- int_low_70-(slope_low*1970)


res <- residuals(fit)
mae <- round(median(abs(res)),2)

min <- min(inc_counts_peryear$n)
max <- max(inc_counts_peryear$n)
mean <- round(mean(inc_counts_peryear$n),3)
std <- round(sd(inc_counts_peryear$n),3)

new_row <- c(num,"INC_COUNT",slope,mae,mean,max,min,std,slope_up,slope_low)

samp_var_slopes<-samp_var_slopes[complete.cases(samp_var_slopes),]
samp_var_slopes[nrow(samp_var_slopes)+1,]<-new_row


write.csv(samp_var_slopes,"analysis_outputs\\table_a1.csv")


gacc_count<-as.data.frame(table(incidents$GACC))
colnames(gacc_count)<-c("GACC","Count")
write.csv(gacc_count,"analysis_outputs\\table_a2.csv")


dev.off()