# ICA
This repository includes all code used to process and analyze data for the citation below.
### Citation: 

**Nowell, B., Jones, K., McGovern, S.M. 2025. Changing wildfire complexity highlights the need for institutional adaptation. Nature Climate Change.**

&nbsp;  
&nbsp;   
&nbsp;   

## Workflow & Scripts

1. In repo directory, create **_input_data_** directory. All necessary input data can be downloaded from this [Dryad data repository](https://doi.org/10.5061/dryad.gxd2547z8).
   **Data in the Dryad repository were accessed as of Dec. 2023. Notes on data availability and sources below. 
3. **run.R** calls all scripts needed to process the input data to reproduce figures and tables. Packages and versions specified.
   *Final figures were created using QGIS. At the top of the analysis scripts (within **_/01_analysis_**), notes are made about the process to recreate final maps with the outputs provided from this code.


## Data Sourcing & Availability
&nbsp;  
Below are descriptions of where and how each dataset in the _input_data_ folder was acquired.

## Wildfire Incidents and Boundaries
### All-Hazards (incident tabular data)
The wildfire incident data were downloaded, [here](https://figshare.com/articles/dataset/All-hazards_dataset_mined_from_the_US_National_Incident_Management_System_1999-2020/19858927/3) (St. Denis et al., 2023). Select the ics209plus-wildfire.zip. The ics209-plug-wf_incidents_1999to2020.csv is used in [*scripts/01_definesample.R*](https://github.com/kejones8/Jurisdictional_Complexity/blob/main/workflow_scripts/01_definesample.R).

### MTBS Fire Boundaries
Downloaded, [here](https://www.mtbs.gov/direct-download) in July 2022. The mtbs_perims_DD.shp is used in [*scripts/02_getMTBSbounds.R*](https://github.com/kejones8/Jurisdictional_Complexity/blob/main/workflow_scripts/02_getMTBSbounds.R).
&nbsp;  
&nbsp;  
&nbsp;  
## Jurisdictional Spatial Data
### WFDSS Data
New version of data downloadable [here](https://data-nifc.opendata.arcgis.com/datasets/nifc::jurisdictional-unit-public/about). Data were projected and geometries cleaned using [data_processing/clean_WFDSS](https://github.com/kejones8/Jurisdictional_Complexity/blob/main/data_acquisition_processing/clean_WFDSS.R). Downloaded version may differ from manuscript.

### BLM Data
File GDB downloaded [here](https://gbp-blm-egis.hub.arcgis.com/datasets/4ec898f8fb104ce4910932d02791563a/about). Unit districts were used. Downloaded version may differ from manuscript.

### BIA Data
Original data downloaded [here](https://biamaps.doi.gov/index.html). This website is now closed; the redirect is to [this page](https://biamaps.geoplatform.gov/BIA-Opendata/), but the same data are not available for download. See [this static map](https://www.bia.gov/bia/ojs/districts) for the districts used.

### State & County
States downloaded [here](https://www2.census.gov/geo/tiger/TIGER2020/STATE/). Counties downloaded [here](https://www2.census.gov/geo/tiger/TIGER2020/COUNTY/).
