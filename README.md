# SABM VIz

These files include all appendices for the Socius paper on Visualizing the Microsteps of the simulations in Stochastic Actor Based Model estimation.

What is included is as follows:

## SABM_Viz_181026.html
This file is the Rmd produced single page of our penultimate version of the manuscript published in Socius, and including the visualization in-line, which Socius unfortunately was unable to do.

## 01_Model & Sim.R
This file is code for running the SAB model, and outputting a single chain from the results in dataframe format. In the example included in the paper, we use the 50th chain from the estimation between Waves I and II. You can change these settings in the code. This model uses the s50 dataset that come included in the RSiena package. The model estimation require no other external data, but execution requires that you have the RSiena and sna packages (and their respective dependencies) installed.
	
## 02_Visualization.R
This file takes the dataframe output from the file above, combines it with the initial network data from the s501 datafile, and converts those into a networkDynamic object that is visualized with the ndtv package. The only assumed external data file for this code to run is the dataframe (named "df") extracted from the fitted model. Execution of this file requires that you have the networkDynamic and ndtv packages (and their respective dependencies) installed. NOTE: There is an alternate plot version available in the code to produce an .mp4 instead of html video (though it loses some of the key functionality).

## 03_Viz_Only.html
This file is only the dynamic visualization (Figure 1) as an embeddable html file. 
