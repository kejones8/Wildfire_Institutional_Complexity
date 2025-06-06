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
2. In repo directory, create **_input_data_** folder. Download some of the input data from this [Dryad data repository](https://doi.org/10.5061/dryad.gxd2547z8) and place in the *_input_data_* folder. 
&nbsp;
&nbsp;   
&nbsp;
3. Download the .csvs specified below from [St. Denis et al, 2023](https://figshare.com/articles/dataset/All-hazards_dataset_mined_from_the_US_National_Incident_Management_System_1999-2020/19858927/3?file=38766504) and place only the .csvs in the *_input_data_* folder. (You will need to download the *_ics209plus-wildfire.zip_*, as you cannot download individual .csvs.)
   * ics209-plus-wf_sitreps_1999to2020.csv

   * ics209-plus-wf_incidents_1999to2020.csv
&nbsp;
&nbsp;   
&nbsp;
4. Download the National GACC shapefile, [here](https://data-nifc.opendata.arcgis.com/datasets/614ad98bdf834c92bf92c4f0fe197903_0/explore?location=3.336959%2C0.314277%2C3.02). Place in the *_input_data_* folder.
&nbsp;
&nbsp;   
&nbsp;
5. **run.R** calls all scripts needed to process the input data to reproduce figures and tables. Packages and versions specified.
   * Final figures were created using QGIS. At the top of the analysis scripts (within **_/01_analysis_**), the necessary steps are documented to recreate final maps with the outputs provided from this code.
&nbsp;
&nbsp;
&nbsp;  
