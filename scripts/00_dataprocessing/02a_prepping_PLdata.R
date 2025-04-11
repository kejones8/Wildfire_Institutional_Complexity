




pl<-read.csv("input_data\\raw_pl_data_2020.csv")
#correct first row,col
pl[1,1]<-"January"

#using this in place of subinc & comp below

incidents<-read.csv("data\\sample_subset.csv")



#in the PL data
#create a vector for years

years<-as.character(seq(1999,2020,1))
#assign the column names
colnames(pl)<-c("Month","Day",years)

#keep month and day, spread years throughout a column
long_form<-reshape::melt(pl,id.vars=c("Month","Day"))

#writing out the product of reshaping
#write.csv(long_form,"cleaned_pl_data.csv")

#rename the PL columns
colnames(long_form)<-c("Month","Date","Year","PL")



#make month table to get numbers for months
mnth_char_vec<-unique(long_form$Month)
mnth_char_vec<-mnth_char_vec[-6]#get rid of June with space at end
mnth_num_vec<-seq(1,12,1)

mnth_tab_tojoin<-cbind(mnth_char_vec,mnth_num_vec)
colnames(mnth_tab_tojoin)<-c("Month_Name","Month_Num")

#now join this table to long_form
long_form_num_mnth<-merge(long_form,mnth_tab_tojoin,by.x="Month",by.y="Month_Name")



#need to make an ID based on date that the tables can be joined on....
#make a unique year, month, date padded code that PL level can be joined to incident table by
#make this column in both tables (incident & long form)
long_form_num_mnth$Y_M_D<-paste0(long_form_num_mnth$Year,long_form_num_mnth$Month_Num,long_form_num_mnth$Date)




#for each unique incident id in "incidents" dataframe, get the discovery date and the final report date
##then tabulate the max pl within that window of dates and the # of days at 5,4,3,2,1

#get only the columns from the incident df that we need to do the PL tabulations
inc_withdates<-as.data.frame(cbind(incidents$INCIDENT_ID,incidents$DISCOVERY_DATE,incidents$FINAL_REPORT_DATE,incidents$START_YEAR))

#condense to single row per incident
uni_inc_withdates<-unique(inc_withdates)
colnames(uni_inc_withdates)<-c("INCIDENT_ID","DISCOVERY_DATE","REPORT_TO_DATE","Year")



uni_inc_withdates$disc_date<-anydate(uni_inc_withdates$DISCOVERY_DATE)
uni_inc_withdates$report_to<-anydate(uni_inc_withdates$REPORT_TO_DATE)
  


####convert the "date" in PL data to actual date
long_form_num_mnth$correct_mnth<-stringr::str_pad(long_form_num_mnth$Month_Num,side="left",width=2,pad="0")
long_form_num_mnth$correct_day<-stringr::str_pad(long_form_num_mnth$Date,side="left",width=2,pad="0")

long_form_num_mnth$year_mnth_day<-as.Date(paste0(long_form_num_mnth$Year,"-",long_form_num_mnth$correct_mnth,"-",long_form_num_mnth$correct_day))



#for every incident number in "uni_inc_withdates" get the
#disc & final date
#then, get all dates between these two from the long_form_num_mnth


#create dfs of incident ID's and max PL & the days spent at each level

incidents_withPLdays<-data.frame()
incidents_withmaxPL<-data.frame()

  
for (i in 1:nrow(uni_inc_withdates)){
  print(i)
  inc_id<-uni_inc_withdates[i,"INCIDENT_ID"]
  disc_date<-uni_inc_withdates[i,"disc_date"]
  final_date<-uni_inc_withdates[i,"report_to"]
  pl_dates_forinc<-long_form_num_mnth[(anydate(long_form_num_mnth$year_mnth_day) >= anydate(disc_date) & anydate(long_form_num_mnth$year_mnth_day) <= anydate(final_date)),]
  nonas<-pl_dates_forinc[!is.na(pl_dates_forinc$PL),]
  pl_tab<-nonas %>% group_by(PL) %>% summarize(count=n())
  inc_id_vec<-rep(inc_id,nrow(pl_tab))

  
  
  inc_id_pl_days<-cbind(inc_id_vec,pl_tab)
  colnames(inc_id_pl_days)<-c("INCIDENT_ID","PL","NumOfDays")
  incidents_withPLdays<-rbind(incidents_withPLdays,inc_id_pl_days)
  
  
  #get maximum PL
  max_pl<-max(nonas$PL,na.rm=T)
  
  incidents_withmaxPL<-rbind(incidents_withmaxPL,c(inc_id,max_pl))
  
}

colnames(incidents_withPLdays)<-c("INCIDENT_ID","PL","NumOfDays")

test_withdates<-merge(incidents_withPLdays,uni_inc_withdates,by="INCIDENT_ID")
test_withdates$event_duration<-difftime(anydate(test_withdates$report_to,),anydate(test_withdates$disc_date),units="day")+1

colnames(incidents_withmaxPL)<-c("INCIDENT_ID","max_PL")



inc_ids_rep<-rep(uni_inc_withdates$INCIDENT_ID, each = 5)
pl_rep<-rep(c(1,2,3,4,5),times=nrow(uni_inc_withdates))
num_of_days<-rep(NA,times=length(pl_rep))


df<-as.data.frame(cbind(inc_ids_rep,pl_rep,num_of_days))
colnames(df)<-c("INCIDENT_ID","PL","NumOfDays")

test<-merge(df,incidents_withPLdays,by.x=c("INCIDENT_ID","PL"),by.y=c("INCIDENT_ID","PL"),all.x=TRUE)


test$NumOfDays.x<-NULL


join_toinc_leveltable<-reshape(test, idvar = "INCIDENT_ID", timevar = "PL", direction = "wide")


colnames(join_toinc_leveltable)<-c("INCIDENT_ID","Days_PL1","Days_PL2","Days_PL3","Days_PL4","Days_PL5")

withxtra_cols<-unique(merge(join_toinc_leveltable,unique(test_withdates[,c("INCIDENT_ID","event_duration")]),by="INCIDENT_ID"))


pl<-merge(withxtra_cols,incidents_withmaxPL)
pl$event_duration<-NULL
pl[is.na(pl)]<-0

write.csv(pl,"data\\pl_days.csv")



