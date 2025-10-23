# FISH_AnalysisPipeline
This set of four scripts can be used to segment histology images (e.g. Rbfox3/NeuN FISH)  and to quantify a secondary or tertiary fluorescent signal (WPRE FISH). 


This pipeline is very similar to the CX5 image analysis pipeline. It requires installation of Python, Cellpose (along with the custom model Ryan built at MIT), and ImageJ. 

The four scripts and their purposes are:

1-Ctx_czi_to_tif.ijm - ImageJ macro that converts czi images to multichannel tiffs (these often have black space due to ROI rotation in ZEN that needs to be cropped/removed prior to the CellPose step used for segmentation in the second script) 

2-COHO-0598P-FISH-CellPose.ipynb - Python, Jupyter notebook containing a script to Batch run CellPose on the .tif images produced by ImageJ

3-COHO-0598P-WPRE-Quantstep-FINAL.ijm - ImageJ macro that uses the segmented outlines saved as ImageJ compatible ROI.txt files (output from CellPose) to define boundaries of cells within which to quantify fluorescent signals of interest (i.e. WPRE). The output of this macro is a set of CSV files for each image that contain the per cell measurements.

4-COHO-0598P_FISH.ipynb - Python, Jupyter notebook containing a script to quantify and plot the csv output of the ImageJ script in step 3.



Installation:

Note These instructions work well on Windows, but the .yml file may need to be adjusted to achieve Linux and Mac OS compatibility

Download and install Anaconda: https://www.anaconda.com/download

Create a conda environment from the yml (cellpose_environment.yml) file included in this repository:

-Download the .yml file and move it to the location where you'd like to create the environment

-Open an anaconda prompt and navigate to the directory containing the .yml file

-Run the following line of code:

 conda env create -f cellpose_environment.yml
Download and install FIJI: https://imagej.net/software/fiji/downloads

Execution including adjusting inputs and parameters:

Filenames, and sometimes certain parameters (e.g. channel IDs, ROI diameters, CellPose Thresholds), must be adjusted to accommodate each dataset. In the section below, the parameters and variables that must (labeled MUST) or occasionally need (labeled DATASET DEPENDENT) to be adjusted within each step/script are described.


Script/Step 1 (ImageJ): Convert to TIF

MUST: Assign the output variable as the directory path which will store the .tif files that are the output of this convert to tif script:

output = "D:/CX5_Analysis_Ryan/COHO-0594V/COHO-0594V_Plate1_Process/Tif/";

MUST: GUI based directory selection When you execute the macro, a window will open and prompt you to assign the directory that contains your .C01 files (which is the same directory you assigned in the previous script). When this happens, navigate to and select the parent directory that contains all of the subdirectories representing each well.

Script/Step 2 (Python): CellPose https://cellpose.readthedocs.io/en/latest/settings.html

MUST: Assign the directory variable as the directory path of the parent directory containing all of the TIF images contained within subdirectories for each well

directory = "D:/CX5_Analysis_Ryan/COHO-0600V/COHO-0600V_SH-SY5Y_Plate2_Process/Tif/"

DATASET DEPENDENT: Note that the following arguments within the cellpose model.eval() function work well for the majority of cell lines when imaged at 20X magnification on the CX5 and the DAPI signal is the first channel. These parameters may need to be adjusted if the nuclei in your images are larger/smaller or the nuclear signal (e.g. DAPI) has been assigned to a different channel.

diameter = This should be an integer value representing the average diameter (in pixel units) of your objects of interest

channels = [1,0] This argument requires two integer values provided as a list. The values represent the primary channel to be segmented followed by an optional secondary channel (e.g. nuclei, in the case of a model that segments cytoplasmic ROIs that are assumed to also contain a nucleus). The second value can be assigned as 0 if only the primary channel should be used for segmentation.

cellprob_threshold = 0

flow_threshold = 0.4

Script/Step 3 (ImageJ): Measure features within masks

MUST: Assign the plate variable as the name of the plate (typically also includes the COHO#)

plate = "COHO-0593V-iGlutaNeurons-Plate1of2";

MUST: Assign the channel variable as the channel number of the signal you wish to quantify (e.g. HA, GFP, etc)

channel = 2; NOTE that this should be assigned as an integer value, not a string

MUST: GUI based directory selection When you execute the macro, a window will open and prompt you to assign the directory that contains your .C01 files. When this happens, navigate to and select the parent directory that contains all of the subdirectories representing each well.

DATASET DEPENDENT: Assign the diameter variable as the diameter by which you would like to expand the ROI to measure the signal of interest. This is helpful if you have segmented nuclei, but want to quantify a cytoplasmic signal for example.

diameter = "1"; NOTE that this should be assigned as a string value, not an integer

Script/Step 4 (Python): Analyze statistics of full dataset

WARNING: There is a lot of customization available/required in this piece of code. The plots and analyses should be tailored to the specific questions that you have about the underlying dataset.
