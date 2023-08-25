
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
	
	selectWindow("z_sum");
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
	
	
	saveAs("Measurements", "/tmp/tptomo_"+essais+"_"+variable+".csv");
}

function perZsurface(essais){
	// analyse sample surface(z)
	selectWindow("mask_ech");
	make_z_sum();
	zsum2csv(essais, "surface");
	selectWindow("z_sum");
	rename("zsum_"+essais+"_surface");
}

function perZporosity(essais){
	// analyse sample surface(z)
	selectWindow("mask_cavites");
	make_z_sum();
	zsum2csv(essais, "cavites");
	selectWindow("z_sum");
	rename("zsum_"+essais+"_cavites");
}

function close_img(){
	selectWindow("mask_matiere");
	close();
	selectWindow("mask_cavites");
	close();
	selectWindow("mask_ech");
	close();
}



essais="01";
essais="06";
//essais="13";

open("/home/clebourlot/Documents/docs-MATEIS/01_Projet/MEALORII/TP/TD_MEALOR_tomo/SCANS INIT/NT4_L_Step_"+essais+".tif");
rename("input_image");
segmentation(120);
perZsurface(essais);
perZporosity(essais);
close_img();
selectWindow("input_image");
close();