

jca<-as.data.frame(st_read("input_data\\incids_mtbs_final.gpkg"))

ica<-read.csv("data\\sample_subset.csv")


inc_jca<-merge(ica,jca,by.x="INCIDENT_ID",by.y="incident_id",all.x=TRUE)


pl<-read.csv("data\\pl_days.csv")
pl$X<-NULL

ica_pl<-merge(inc_jca,pl,by="INCIDENT_ID",all.x=TRUE)
ica_pl$geom<-NULL
ica_pl$START_YEAR.y<-NULL

gacc_assignment<-read.csv("data\\gacc_assign.csv")[,c(1,6)]
colnames(gacc_assignment)<-c("INCIDENT_ID","gacc")

incids_withnewgacc<-merge(ica_pl,gacc_assignment,by="INCIDENT_ID",all.x=TRUE)


write.csv(incids_withnewgacc,"data\\ica_jca_data.csv")


