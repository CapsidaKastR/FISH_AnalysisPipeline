# FISH_AnalysisPipeline
This set of four scripts can be used to segment histology images (e.g. Rbfox3/NeuN FISH)  and to quantify a secondary or tertiary fluorescent signal (WPRE FISH). 


This pipeline is very similar to the CX5 image analysis pipeline. It requires installation of Python, Cellpose (along with the custom model Ryan built at MIT), and ImageJ. 

The four scripts and their purposes are:

1-Ctx_czi_to_tif.ijm - ImageJ macro that converts czi images to multichannel tiffs (these often have black space due to ROI rotation in ZEN that needs to be cropped/removed prior to the CellPose step used for segmentation in the second script) 

2-COHO-0598P-FISH-CellPose.ipynb - Python, Jupyter notebook containing a script to Batch run CellPose on the .tif images produced by ImageJ

3-COHO-0598P-WPRE-Quantstep-FINAL.ijm - ImageJ macro that uses the segmented outlines saved as ImageJ compatible ROI.txt files (output from CellPose) to define boundaries of cells within which to quantify fluorescent signals of interest (i.e. WPRE). The output of this macro is a set of CSV files for each image that contain the per cell measurements.

4-COHO-0598P_FISH.ipynb - Python, Jupyter notebook containing a script to quantify and plot the csv output of the ImageJ script in step 3.




