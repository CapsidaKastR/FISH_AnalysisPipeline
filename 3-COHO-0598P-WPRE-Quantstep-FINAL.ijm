setBatchMode(false);

dir = getDirectory("Choose a Directory ");
diameter = "1";
imagelist = getFileList(dir);

for (ii=0; ii<imagelist.length; ii++) {
  	
      if (endsWith(imagelist[ii], ".tif")){
      	 print(dir+imagelist[ii]);
         processImage(dir+imagelist[ii]);
      }
}

function processImage(path) {
			print(path);
			open(path);
			
			//get the image dimensions so that the edge ROIs can be deleted
			getDimensions(width, height, channels, slices, frames);
			filename = getInfo("image.filename");
			
			run("Split Channels");
			selectImage("C2-" + filename);
			//run("Duplicate...", " ");
			//setThreshold(2418, 65535, "raw");
			//run("Convert to Mask");

			//Measure thresholded DAPI features including area and standard deviation of the signal which can be used to filter out dead cells
			run("Set Measurements...", "area mean median standard min centroid integrated area_fraction limit display nan redirect=[C2-" + filename + "] decimal=3");

			//Clear the results tab
			run("Clear Results");
			
			//Open the CellPose ROIs
			 	
			roiManager("reset");
			rois = replace(path, ".tif", "_rois.zip");
			open(rois);
			
			//Delete the edge ROIs from the ROI manager
			for(i=roiManager("count");i>0;i--){
				roiManager("select", i-1);
				getSelectionBounds(x, y, width1, height1);
				if ((x==0)||(y==0)||((x+width1)>=width-1)||((y+height1)>=height-1)) {
					roiManager("delete");
				}
			}
			
			//Determine how many ROIs were left after the edge ROIs were deleted
			c= roiManager("count");
			for (k = 0; k < c; k++) {
				roiManager("Select", k);
				run("Measure");
			}
			
			saveAs("Results", dir + imagelist[ii] + "CellPose_DAPI.csv");
			
			run("Clear Results");
			
			//Measure the signal of interest within an expanded area surrounding the nucleus
			run("Set Measurements...", "area mean median standard min centroid integrated area_fraction limit display nan redirect=[C3-" + filename + "] decimal=3");
			selectImage("C3-" + filename);
			
			for (l = 0; l < c; l++) {
				roiManager("Select", l);
				run("Measure");
			}
			saveAs("Results", path + "CellPose_WPRE.csv");
			//run("Close All");
			run("Clear Results");
			
			//Measure the signal of interest within a halo/donut surrounding the nucleus
			
			setThreshold(1, 65535, "raw");
			run("Set Measurements...", "area mean median standard min centroid integrated area_fraction limit display nan redirect=[C3-" + filename + "] decimal=3");
			
			for (l = 0; l < c; l++) {
				roiManager("Select", l);
				run("Clear", "slice"); //mask the nucleus
				run("Enlarge...", "enlarge="+diameter); //Specify by how many microns you want to enlarge the halo/donut.
				run("Measure");
			}
			
			saveAs("Results", path + "CellPose_HAdonut-" + diameter + "um.csv");
			run("Close All");
			if (isOpen("Exception")) {
				print("File: "+path+ " threw an exception");
			    selectWindow("Exception");
			    run("Close");
	     }
	     setBatchMode(true);
}
			
print("FINSIHED WITH LAST IMAGE IN DIRECTORY");