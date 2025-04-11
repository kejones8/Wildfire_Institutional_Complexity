options(scipen=999)

#load libraries

incidents<-read.csv("input_data//ics209-plus-wf_incidents_1999to2020.csv")

sitreps<-read.csv("input_data//ics209-plus-wf_sitreps_1999to2020.csv")


wf_inc<-incidents[incidents$INCTYP_ABBREVIATION %in% c("WF","WFU","CX"),]

#smush the incident IDs and sitreps together
wf_inc_sitrep<-merge(wf_inc,sitreps,by="INCIDENT_ID")


#make list of incident_ids that have type 1/2/NIMO designations
type12_incid_nimo<-wf_inc_sitrep$INCIDENT_ID[wf_inc_sitrep$IMT_MGMT_ORG_DESC %in% c("Type 2 Team","Type 1 Team","Type 2 IC","Type 1 IC","NIMO")] 

#baseline for sample size
type12_wf_inc_nimo<-wf_inc[wf_inc$INCIDENT_ID %in% type12_incid_nimo,]
num_type12nimo<-length(unique(type12_wf_inc_nimo$INCIDENT_ID))

write.csv(type12_wf_inc_nimo,"data\\sample_subset.csv")
