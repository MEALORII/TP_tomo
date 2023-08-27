
function segmentation(seuil){
	run("Duplicate...", "title=raw_data duplicate");
	
	setThreshold(seuil, 255);
	setOption("BlackBackground", true);
	run("Convert to Mask", "method=Default background=Dark black");
	
	
	run("Analyze Particles...", "size=100000-Infinity pixel show=Masks stack");
	run("Invert LUT");
	rename("mask_matiere");
	
	run("Duplicate...", "title=mask_ech duplicate");
	run("Fill Holes", "stack");
	
	
	selectWindow("raw_data");
	close();
	
	
	imageCalculator("Subtract create stack", "mask_ech","mask_matiere");
	rename("mask_cavites");
}

function make_z_sum(){
	
	run("Reslice [/]...", "output=1.000 start=Left avoid");
	setSlice(647);
	rename("tmp1");
	run("Divide...", "value=255 stack");
	setMinAndMax(0, 0);
	run("Z Project...", "projection=[Sum Slices]");
	rename("tmp2");
	run("Reslice [/]...", "output=1.000 start=Left avoid");
	rename("tmp3");
	run("Z Project...", "projection=[Sum Slices]");
	
	rename("z_sum");
	
	selectWindow("tmp1");
	close();
	selectWindow("tmp2");
	close();
	selectWindow("tmp3");
	close();
}

function zsum2csv(essais, variable){

	selectWindow("z_sum");
	getDimensions(width, height, channels, slices, frames);
	makeLine(1, 0, width-1, 0);

	run("Clear Results");
	profile = getProfile();
	for (i=0; i<profile.length; i++){
	  setResult(essais, i, profile[i]);
	}
	updateResults();
	
	
	saveAs("Measurements", "/tmp/tptomo_"+essais+"_"+variable+".csv");}

function perZsurface(essais){
	// analyse sample surface(z)
	selectWindow("mask_ech");
	make_z_sum();
	zsum2csv(essais, "surface");
	selectWindow("z_sum");
	//rename("zsum_"+essais+"_surface"); // uncomment to keep open, for live demo
	close();
}

function perZporosity(essais){
	// analyse sample surface(z)
	selectWindow("mask_cavites");
	make_z_sum();
	zsum2csv(essais, "cavites");
	selectWindow("z_sum");
	//rename("zsum_"+essais+"_cavites"); // uncomment to keep open, for live demo
	close();
}

function analyse3d(essais){
	selectImage("mask_cavites");
	// run the 3DManager from the GUI, and use the macro recorder to define your needed options
	run("3D Manager Options", "volume 3d_moments centroid_(pix) centre_of_mass_(pix) bounding_box distance_between_centers=10 distance_max_contact=1.80 drawing=Contour");
	run("3D Manager");
	Ext.Manager3D_Segment(128, 255);
	Ext.Manager3D_AddImage();
	Ext.Manager3D_SelectAll();
	Ext.Manager3D_Measure();
	
	Ext.Manager3D_SaveResult("M","/tmp/tptomo_"+essais+"_cavites_3danalysis.csv");
	Ext.Manager3D_CloseResult("M");
	
	selectImage("mask_cavites-3Dseg");
	close();
	Ext.Manager3D_Close();
}



// choose the step you want to analyse
// of course, a loop on the scans can be made
essais="01";
//essais="06";
//essais="13";

// path to the .tif file
open("/home/clebourlot/Documents/docs-MATEIS/01_Projet/MEALORII/TP/TD_MEALOR_tomo/SCANS INIT/NT4_L_Step_"+essais+".tif");
rename("input_image");
// segmentation and preparation of the different masks
segmentation(120);

// analyse per slice
perZsurface(essais);  // on the sample mask
perZporosity(essais); // on the porosity mask


// close the image windows, to save space and prevent crash

selectWindow("input_image");
close();
selectWindow("mask_matiere");
close();
selectWindow("mask_ech");
close();

// the analysis 3D can be highly memory consuming
analyse3d(essais);


selectImage("mask_cavites");
close();
if (isOpen("Log")) {
     selectWindow("Log");
     run("Close" );
}
if (isOpen("Console")) {
     selectWindow("Console");
     run("Close" );
}
if (isOpen("Results")) {
     selectWindow("Results");
     run("Close" );
}
