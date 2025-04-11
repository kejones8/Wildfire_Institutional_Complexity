

##read in the incident table

incidents<-read.csv("data\\ica_jca_data.csv")


incidents$VALS_AT_RISK<-incidents$STR_DAMAGED_TOTAL+incidents$STR_DESTROYED_TOTAL+incidents$STR_THREATENED_MAX
incidents["VALS_AT_RISK"][is.na(incidents["VALS_AT_RISK"])] <- 0
incidents$NPL_DAYS_4_5<-incidents$Days_PL4+incidents$Days_PL5
incidents$FINAL_SQKM <- incidents$FINAL_ACRES * 0.004

#creating variables that aren't already in the incident table
var_names<-c("FINAL_SQKM","ALLJUR_ENGAG_CNT","VALS_AT_RISK","NPL_DAYS_4_5")

names(incidents)<-toupper(names(incidents))

inc_dups_bygacc_sub<-incidents[,c("INCIDENT_ID","START_YEAR.X","GACC",var_names)]



#group dataframe by GACC
grouped<-inc_dups_bygacc_sub %>%
  split(f = as.factor(.$GACC))



#get a list of gacc names to use in file output naming
gacc_names<-names(grouped)


hmm<-inc_dups_bygacc_sub %>% group_by(GACC,START_YEAR.X) %>% summarise(n=n())
#create table such that we don't drop years where no incident is counted (preserve 0 years) & count gacc

#counting incidents by gaccs
allgaccs_allyears0<-cbind(gacc=sort(rep(gacc_names,length(1999:2020))),year=rep(seq(1999,2020,1),10),count=rep(0,length(1999:2020)))


gaccs_0counts<-merge(hmm,allgaccs_allyears0,by.x=c("GACC","START_YEAR.X"),
                     by.y=c("gacc","year"),all.y=TRUE)

gaccs_0counts$n[is.na(gaccs_0counts$n)] <- 0

mean_inc_count_bygacc <- gaccs_0counts %>%
  group_by(GACC) %>%
  dplyr::summarize(Mean = mean(n, na.rm=TRUE))



gacc_var_slopes<-data.frame(matrix(NA, ncol = 11))
colnames(gacc_var_slopes)<-c("GACC","variable","slope","slope_up","slope_up","mean_abs_error","mean","max","min","std_dev","gacc_avg")

#set counter 
count=0

###plot all gaccs, all variables
for (i in 1:length(gacc_names)){
  
  #define which gacc we're working with
  gacc<-grouped[[i]]
  

  gacc_name<-gacc_names[i]
  
  #loop through each variable name to produce plot
  for (var in 1:length(var_names)){
    count=count+1
    
    #define variable
    var_name<-var_names[var]
    
    gacc_mean_of_var <- mean(gacc[,c(var_name)],na.rm=TRUE)
    
    #select the columns to pass to timeseries regression plot
    df_to_plot_bleh<-unique(gacc[,c("INCIDENT_ID","START_YEAR.X",var_name)])
    df_to_plot<-unique(df_to_plot_bleh[complete.cases(df_to_plot_bleh),])
    
    fix_years_0cnt<-cbind(year=seq(1999,2020,1),num=rep(0,length(1999:2020)))
    
    #rework those columns to return mean values of the variable
    mean_table_draft<-df_to_plot %>% group_by(START_YEAR.X) %>% dplyr::summarize(mean=mean(.data[[var_name]])/gacc_mean_of_var)
    
    mean_table<-merge(mean_table_draft,fix_years_0cnt,by.x="START_YEAR.X",
                      by.y="year",all.y=TRUE)
   
     mean_table$date<-as.POSIXct(paste0(mean_table$START_YEAR.X,"-01-01"))
    
     
     ploop<-openair::TheilSen(mean_table,pollutant="mean",date.format = "%Y",autocor=FALSE,shade="white",data.col="black",alpha=0.1,text.col="transparent",xlab = "Year",trend = list(lty = c(1, 5), lwd = c(2, 1), col = c("black", "blue")),plot=TRUE)#autocor=TRUE
     
    
    if (var_name != "ALLJUR_ENGAG_CNT"){
      
      mean_table$mean[is.na(mean_table$mean)]<- 0
      
    }
    
    
    options(scipen=999)
    plot.new()

    mean <- mean_table[['mean']]
    yr <- mean_table[['START_YEAR.X']]
    
    fit<-theilsen(mean ~ yr)

    slope_openair <- round(ploop$data$main.data$slope[1],2)
    slope_up <- round(ploop$data$res2$upper[1],2)
    slope_low <- round(ploop$data$res2$lower[1],2)
    slope<-round(coef(fit)[2],3)
    res <- residuals(fit)
    mae <- median(abs(res))
    int <- round(coef(fit)[1],3)
    min<-min(df_to_plot[,var_name])
    max<-max(df_to_plot[,var_name])
    avg<-round(mean(df_to_plot[,var_name]),3)
    std_dev<-round(sd(df_to_plot[,var_name]),3)
    gacc_cum_avg<-round(gacc_mean_of_var,3)

    new_row<-c(gacc_name,var_name,slope,slope_up,slope_low,mae,avg,max,min,std_dev,gacc_cum_avg)
    
    #append it
    gacc_var_slopes[count,]<-new_row
    
    
  }
}


#have to do incident counts separately, no averaging
gaccs_0counts$START_YEAR.X<-as.numeric(gaccs_0counts$START_YEAR.X)

var_names<-"INC_COUNT"
#set counter 
count=0
gacc_row_count <- 40

###plot all gaccs, all variables
for (i in 1:length(gacc_names)){
  
  
  #gacc<-unique(gacc_bleh[complete.cases(gacc_bleh),])
  gacc_name<-gacc_names[i]
  
  #define which gacc we're working with
  gacc<-gaccs_0counts[gaccs_0counts$GACC==gacc_name,]
  
  gacc_mean_of_var <- mean(gacc$n)
  gacc$INC_COUNT <- gacc$n
  
  #loop through each variable name to produce plot
  for (i in 1:length(var_names)){
    
    count=count+1
    gacc_row_count=gacc_row_count+1
    
    #define variable
    var_name<-var_names[i]
    

    fix_years_0cnt<-cbind(year=seq(1999,2020,1),num=rep(0,length(1999:2020)))
    
    
    # #rework those columns to return mean values of the variable
    mean_table_draft<-gacc %>% group_by(START_YEAR.X) %>% dplyr::summarize(mean=mean(.data[[var_name]])/gacc_mean_of_var)
    
 
    options(scipen=999)
    
    mean_table_draft$date<-as.POSIXct(paste0(mean_table_draft$START_YEAR.X,"-01-01"))
    mean <- mean_table_draft[['mean']]
    yr <- mean_table_draft[['START_YEAR.X']]
    fit<-theilsen(mean ~ yr)

    #get the slope and other summary statistics
    slope<-round(coef(fit)[2],3)
    int <- round(coef(fit)[1],3)
    res <- residuals(fit)
    mae <- round(median(abs(res)),3)
    min<-min(gacc$INC_COUNT)
    max<-max(gacc$INC_COUNT)
    avg<-round(mean(gacc$INC_COUNT,3))
    std_dev<-round(sd(gacc$INC_COUNT),3)
    gacc_cum_avg<-round(gacc_mean_of_var,3)
    
    ploop<-openair::TheilSen(mean_table_draft,pollutant="mean",date.format = "%Y",autocor=FALSE,shade="white",data.col="black",alpha=0.1,text.col="transparent",xlab = "Year",trend = list(lty = c(1, 5), lwd = c(2, 1), col = c("black", "blue")),plot=FALSE)#autocor=TRUE
    

    slope_up <- round(ploop$data$res2$upper[1],3)
    slope_low <- round(ploop$data$res2$lower[1],3)
    
    new_row<-c(gacc_name,var_name,slope,slope_up,slope_low,mae,avg,max,min,std_dev,gacc_cum_avg)
    
    #append it
    gacc_var_slopes[gacc_row_count,]<-new_row
    
  
 
  }
}



gacc_var_slopes$mean[gacc_var_slopes$variable == "INC_COUNT"] <- NA



write.csv(gacc_var_slopes,"analysis_outputs//table_a3.csv")













