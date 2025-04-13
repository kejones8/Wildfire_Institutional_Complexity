# Wildfire Institutional Complexity
This repository includes all code and links to datasets used for the citation below.
## Citation (DOI pending) 

**Nowell, B., Jones, K., McGovern, S.M. 2025. Changing wildfire complexity highlights the need for institutional adaptation. Nature Climate Change.**

&nbsp;  
https://doi.org/10.5281/zenodo.15199351
 &nbsp; 

## Workflow & Scripts
 
1. Download or clone repository.
&nbsp;
&nbsp;   
&nbsp;  
3. In repo directory, create **_input_data_** folder. Download input data from this [Dryad data repository](https://doi.org/10.5061/dryad.gxd2547z8) and place in *_input_data_* folder. This is necessary to successfully run the code. 
   * Data stored in the Dryad repository are current as of Dec. 2023. Notes on data availability and source updates below. 
&nbsp;
&nbsp;   
&nbsp;  
3. **run.R** calls all scripts needed to process the input data to reproduce figures and tables. Packages and versions specified.
   * Final figures were created using QGIS. At the top of the analysis scripts (within **_/01_analysis_**), the necessary steps are documented to recreate final maps with the outputs provided from this code.
&nbsp;
&nbsp;
&nbsp;  

## Data Sourcing & Availability
&nbsp;  
Information about where each dataset from the [Dryad data repository](https://doi.org/10.5061/dryad.gxd2547z8) was generated or acquired.

### National_GACC_Current_20200226.shp
  * Data found [here](https://data-nifc.opendata.arcgis.com/datasets/614ad98bdf834c92bf92c4f0fe197903_0/explore?location=3.336959%2C0.314277%2C3.02).

### ics209-plus-wf_incidents_1999to2020.csv & ics209-plus-wf_sitreps_1999to2020.csv
  * The wildfire incident and situation report data were downloaded, [here](https://figshare.com/articles/dataset/All- 
    hazards_dataset_mined_from_the_US_National_Incident_Management_System_1999-2020/19858927/3?file=38766504) (St. Denis et al., 2023). Download the 
    ics209plus-wildfire.zip. 

### incids_mtbs_final.gpkg
* Dataset is the final output from the [Jurisdictional Complexity github repository](https://github.com/kejones8/Jurisdictional_Complexity). Review repository .README for additional data availability.
* Repository for published manuscript: <br>
&nbsp;
&nbsp;
&nbsp;
**Jones, K., Vukomanovic, J.V., Nowell, B., McGovern, S.M. 2024. Mapping Wildfire Jurisdictional Complexity Reveals Opportunities for Regional Co-Management. Global Environmental Change 84, 102084. https://doi.org/10.1016/j.gloenvcha.2024.102804.** 

### raw_pl_data_2020.csv
  * Data received March 2023 through personal communications with the National Interagency Fire Center. 
