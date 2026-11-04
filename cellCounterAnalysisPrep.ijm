// adjust brightness contrast etc.
getDimensions(imW, imH, imC, imS, imF);
Stack.setDisplayMode("color");
for (ii = 0; ii < imC; ii++){
	Stack.setPosition(ii+1,imS/2,1);
//	if (imC == 2){
//		if (ii == 0){
//			waitForUser;
//			run("DAPI");
//		}
//		if (ii == 1){
//			waitForUser;
//			run("Grays");
//		}
//	}

	// adjust image contrast
	run("Brightness/Contrast...");
	run("Enhance Contrast", "saturated=0.2");
}

// prepare both split and composite image for cell counter analysis
run("Duplicate...", "duplicate");

// choose original image for splitting channels
imList = getList("image.titles");

for (jj=0; jj<imList.length; jj++){
	selectWindow(imList[jj]);
	// get rid of image label so randomised images cannot be deciphered
	for (kk = 0; kk < imC; kk++){
		for (ii = 0; ii < imS; ii++){
			Stack.setPosition(kk,ii+1,1);
			run("Set Label...", "label=[ ]");
		}
		Stack.setPosition(kk+1,imS/2,1);
	}
	
	// get z-axis profile for one image and separate channels for the other
	if (matches(imList[jj],".*-1.tif")){ /// was previously ".*-1.*" but stopped working on some images so perhaps wildcard is broken without
		run("Plot Z-axis Profile");
	}
	else {
		run("Split Channels");
	}
}

// close DAPI channel image as don't need for cell counter plugin
imList = getList("image.titles");
for (jj=0; jj<imList.length; jj++){
	selectWindow(imList[jj]);
	if (startsWith(imList[jj],"C1")){
		close();
	}
	else {
//		run("Out [-]");
//		run("Out [-]");
	}
}
