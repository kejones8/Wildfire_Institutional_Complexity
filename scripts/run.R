
#R. Version 4.2.1

#install necessary packages

#packages, version used

# install.packages("reshape")#0.8.9
# install.packages("stringr")#1.5.1
# install.packages("anytime")# 0.3.9
# install.packages("sf")# 1.0-19
# install.packages("dplyr")#1.1.4
# install.packages("foreach")#1.5.2
# install.packages("doParallel")#1.0.17
# install.packages("ggplot2")#3.5.1
# install.packages("cowplot")#1.13
# install.packages("deming")#1.4-1
# install.packages("car")#3.1-3
# install.packages("mblm")#0.12.1
# install.packages("openair")#2.18-2
# install.packages("Kendall")#2.2.1

library(reshape)
library(stringr)
library(anytime)
library(sf)
library(dplyr)
library(foreach) #for parallelizing intersection
library(doParallel)
library(ggplot2)
library(cowplot)
library(deming)
library(car)
library(mblm)
library(openair)
library(Kendall)

`%notin%` <- Negate(`%in%`)

#if directories don't exist, make them
#for created datasets
ifelse(!dir.exists(file.path("data")), dir.create(file.path("data")), FALSE) 
#for all analysis outputs 
ifelse(!dir.exists(file.path("analysis_outputs")), dir.create(file.path("analysis_outputs")), FALSE)
ifelse(!dir.exists(file.path("analysis_outputs/maps")), dir.create(file.path("analysis_outputs/maps")), FALSE)
ifelse(!dir.exists(file.path("analysis_outputs/maps/fig1-5_shapefiles")), dir.create(file.path("analysis_outputs/maps/fig1-5_shapefiles")), FALSE)



#data processing
source("scripts\\00_dataprocessing\\01_getsample_allhazardsdata.R")
print("01_getsample_allhazardsdata.R done")
source("scripts\\00_dataprocessing\\02a_prepping_PLdata.R")
print("02a_prepping_PLdata.R done")
source("scripts\\00_dataprocessing\\02b_assignGACC.R")
print("02b_assignGACC.R done")
source("scripts\\00_dataprocessing\\03_combineICAvars.R")
print("03_combineICAvars.R done")

#data analysis - figure & table creation
source("scripts\\01_analysis\\fig1a_bargraph.R")
print("fig1a_bargraph.R done")
source("scripts\\01_analysis\\fig2-5c_bargraphs.R")
print("fig2-5c_bargraphs.R done")
source("scripts\\01_analysis\\fig2-5b_trendline_tableA1-2.R")
print("fig2-5b_trendline_tableA1-2.R done")
source("scripts\\01_analysis\\table_A3.R")
print("table_A3.R done")
source("scripts\\01_analysis\\fig1-5_slopemaps.R")
print("fig1-5_slopemaps.R done")

