//Macro to open all files in a folder, decide whether to split channels,
//and then save images in destination directory. Also takes care to remove duplicates from file
//names as can occur when saving images with multiple scenes from Zeiss .czi files.

macro "Process My Files" {
    dir1 = getDirectory("Choose Source Directory ");
    dir2 = getDirectory("Choose Destination Directory ");
    list = getFileList(dir1);

	Dialog.create("Split channels?")
    	Dialog.addChoice("Do you want to split the channels of these images?",newArray("Yes","No"));
    	Dialog.addChoice("Do you want to bin images (2x2x1 XYZ)?",newArray("Yes","No"));
    	Dialog.addChoice("Do you want to make a maximum projection?",newArray("Yes","No"));
	Dialog.show();
	
	splitChoice = Dialog.getChoice();
	binChoice = Dialog.getChoice();
	maxChoice = Dialog.getChoice();
	
//		userChoice = parseFloat(Dialog.getChoice()); // convert text choice to integer with parseFloat
	
    setBatchMode(true);
    
    // process each image file (may contain multiple series/scenes)
    for (i=0; i<list.length; i++) {
        showProgress(i+1, list.length);
        // open images using Bio-Formats
        if (endsWith(list[i],".czi")){
        	s = "open=["+dir1+list[i]+"] open_all_series autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT";
        	run("Bio-Formats Importer", s);
    }	else if (endsWith(list[i],".dv")){
        	s = "open=["+dir1+list[i]+"] autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT";
        	run("Bio-Formats Importer", s);
    }	else if (endsWith(list[i],".tif")){
    		s = "open=["+dir1+list[i]+"] autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT";
        	run("Bio-Formats Importer", s);
    }	else {
    		continue;
    }
    
    	
    	// maximum projection of all images
    	if (maxChoice == "Yes"){
    		imList1 = getList("image.titles");
    		for (ii=0; ii<imList1.length; ii++){
    			selectWindow(imList1[ii]);
	    		run("Z Project...", "projection=[Max Intensity]");
    		}
    	}
    	
    	// split channels for each image separately
    	if (splitChoice == "Yes"){
    		imList1 = getList("image.titles");
    		for (ii=0; ii<imList1.length; ii++){
    			selectWindow(imList1[ii]);
	    		run("Split Channels");
    		}
    	}
		    	
    	// save each image/channel of image separately, if chosen to split
    	imList = getList("image.titles");
        for (jj=0; jj<imList.length; jj++){
        	selectWindow(imList[jj]);
        	
        	if (binChoice == "Yes"){
        		run("Bin...", "x=2 y=2 z=1 bin=Average");
        	}
        	
        	fileName = imList[jj];
        	
        	//// FIX DUPLICATES IN FILE NAMES FROM SCENES ////
			// Find the index of "..." or " - " in the file name
			ellipsisIndex = lastIndexOf(fileName, "...");
			hyphenIndex = lastIndexOf(fileName, " - ");
			
			if (ellipsisIndex > 0 || hyphenIndex > 0) {
				// Split the file name into parts
			 	parts = split(fileName, "_");
			 	
			 	// Remove the duplicate parts as well as those containing "..."
			    nonDupFileName = "";
			    for (j=0; j<parts.length; j++) {
					if (j == 0) {
						nonDupFileName = parts[j];
					} 
					else {
						if (nonDupFileName.indexOf(parts[j]) == -1 && !matches(parts[j],".*\\.{3}.*")) {
					    	nonDupFileName = nonDupFileName + "_" + parts[j];
					    }
					}
			    }
			    
			    print(nonDupFileName);
				    
//			    // Remove number and file format for clean file name base
//				splitFileName = split(nonDupFileName, "-(\\d{2})-Airyscan Processing\\.(tif|czi)");
//				cleanFileName = splitFileName[0];
//			
//				print(cleanFileName);
				
			    // Find the image number "-XX.tif" in the original file name
			    imageRegExp = ".*-(\\d{2})\\.(tif|czi).*";
			    imageRegExp_Airyscan = ".*-(\\d{2})-Airyscan Processing\\.(tif|czi).*";
			    if (matches(fileName, imageRegExp)) {
				    // Remove number and file format for clean file name base
					splitFileName = split(nonDupFileName, "(-\\d{2}\\.(tif|czi))");
					cleanFileName = splitFileName[0];
			        imageNumberPart = "-" + replace(nonDupFileName, imageRegExp, "$1");
			    }
			    else if (matches(fileName, imageRegExp_Airyscan)) {
				    // Remove "Airyscan Processing" and file format for clean file name base
					splitFileName = split(nonDupFileName, "(_-\\d{2}-Airyscan)");
					cleanFileName = splitFileName[0];
					// Get rid of "Airyscan Processing" part and just take number
					splitAiryscan = split(nonDupFileName, "(-Airyscan)");	
					splitFileNum = split(splitAiryscan[0],"-");
					imageNumberPart = "-" + splitFileNum[splitFileNum.length-1];
			    }
			    else {
			    	print("Cannot find image number");
			    }
			
			    // Extract scene number "#XX" from the original file name
				seriesRegExp = ".*\\#(\\d{1,2}).*";
			    if (matches(fileName, seriesRegExp)) {
			        seriesNumber= replace(nonDupFileName, seriesRegExp, "$1");
			        
			        if (parseInt(seriesNumber) > 9){
			        	seriesNumberPart = "-" + toString(parseInt(seriesNumber));
			        }
			        else if (parseInt(seriesNumber) < 10){
			        	seriesNumberPart = "-0" + toString(parseInt(seriesNumber));
			        }
					// Concatenate the extracted parts to the cleaned file name
			    	cleanFileName += imageNumberPart + seriesNumberPart + ".tif";
			    }
			    else {
			    	print("Cannot find series number");
			    	// Concatenate the extracted parts to the cleaned file name
			    	cleanFileName += imageNumberPart + ".tif";
			    }
			}
			else {
			    // Handle the case when "..." is not found
			    // Here, you can add any fallback action or error handling
//			    print("Duplicate indicators not found in the file name - no scenes in this image?");
			    cleanFileName = fileName;
			}
			imagePath = dir2+cleanFileName;			
        	saveAs("tiff",imagePath);
        }
		close("*");
        }
    }
    setBatchMode(false);
}