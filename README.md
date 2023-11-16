
# slip_system_analysis_tools
This repository contains a modification from the code published here:

Gibson, J.S.K.-L.; Pei, R.; Heller, M.; Medghalchi, S.; Luo,W.; Korte-Kerzel, S.
Finding and Characterising Active Slip Systems: A Short Review and Tutorial with Automation Tools
Materials 2021, 14, 407
[https://doi.org/10.3390/ma14020407]


### Slip_Line_Analysis
This folder contains the MATLAB scripts required to perform the automated slip line analysis.
Download them all and run SlipLines_main.m - instructions for use are included in the top comments.
This project requires the MTEX toolbox in order to function. This must be downloaded separately and loaded at the start of the analysis (line 17).
This code was developed using MatLab 2018b and MTEX-5.3.1.
The new version of the code was developed using Matlab 2020b and Mtex-5.7.0

### We updated the Slip line analysis by the following:
- saving of x and y coordinates of the lines, to make reanalysis later possible
- saving of redundant slip systems (i.e if slip sys _a_ has a deviation angle of 3.0 but slip sys _b_ of 2.8, both are saved)
- adding the angle with the surface so we could theoretically rule out the very flat ones
- minor changes of plotting the images and selecting the points of the slip lines
