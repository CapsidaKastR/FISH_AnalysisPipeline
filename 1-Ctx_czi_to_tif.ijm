dir = getDirectory("Choose a Directory ");

function CompositeAndContrast(dir, filename){
	
	filename = list[i];
	print(dir + filename);
	// Enable Bio-Formats Macro Extensions
	run("Bio-Formats Macro Extensions");
	
	// Open the 3rd series (index 3)
	Ext.setId(dir + filename);
	Ext.setSeries(2);
  	// Get the series count
    Ext.getSeriesCount(seriesCount);
        
    // Print the result
    print(filename + ": " + seriesCount + " series");
	
	run("Bio-Formats Importer", "open=["+ dir + filename + "] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_1");
	flnm = getInfo("image.filename");
	saveAs("tif", dir + flnm);
	

}

setBatchMode(true);
list = getFileList(dir);

for (i = 0; i < list.length; i++) {
	if (endsWith(list[i], ".czi")){
		CompositeAndContrast(dir, list[i]);
	}
}

print("Finished!")	
	