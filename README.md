
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

## Added Scripts, to analyse old data again
in the scripts you still need to define your crystalstrucutre and slip systems again!!!

### extract_lines_from_image 
- can extract the already marked slip lines from older images based on color filtering and a following hough transform and writes the x-y coordinates to an excel file- 

### reanalyse_slip_lines_new
this is used to reanalyse the slip lines, where you allready have x and y coordinates of your slip lines. It gets the orientation (euler angles) from the old analysis excel file and lets you select the missing ones on the image
in the beginning you can select the folder name, where you have the .csv extracted by extract_lines_from_image (values = readtable(....)) and the path which contains your old analyses (containting the euler angles).
If you notice, that you select a wrong line, you could press ctrl + c . The script will memorise the loop variables. if you start the script again from the for loop, you can continue withe last image again (if it not works correctly, please provide control_i, check_error and control_j, manually)

### reanalyse_oldsliplines
ranalyse_oldsliplines is used to reanalyse the old analysis datasets if youd e.g. by TEM analysis detect a possible new candidate for slip line analysis

**if you notice bugs, you are welcome to report.**
