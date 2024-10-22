# SABM Viz

These files include the main document and all appendices for my [*Socius* paper](https://journals.sagepub.com/doi/full/10.1177/2378023118816545) with David Schaefer on Visualizing the Microsteps of the simulations in Stochastic Actor Based Model estimation.

What is included is as follows:

## [Full Manuscript](https://jimiadams.github.io/SABM-VIz/)
This file is the Rmd-produced single page of our penultimate version of the manuscript that was published in *Socius*. It includes the main visualization in-line as we intended, but *Socius* unfortunately was unable to do.

## 01_Model & Sim.R
This file is code for running the SAB model, and outputting a single chain from the results in dataframe format. In the example included in the paper, we use the 50th chain from the estimation between Waves I and II. You can change these settings in the code. This model uses the s50 dataset that come included in the RSiena package. The model estimation require no other external data, but execution requires that you have the [RSiena](https://cran.r-project.org/web/packages/RSiena/index.html) and [sna](https://cran.r-project.org/web/packages/sna/index.html) packages (and their respective dependencies) installed.
	
## 02_Visualization.R
This file takes the dataframe output from the file above, combines it with the initial network data from the s501 datafile, and converts those into a networkDynamic object that is visualized with the ndtv package. The only assumed external data file for this code to run is the dataframe (named "df") extracted from the fitted model. Execution of this file requires that you have the [networkDynamic](https://cran.r-project.org/web/packages/networkDynamic/index.html) and [ndtv](https://cran.r-project.org/web/packages/ndtv/index.html) packages (and their respective dependencies) installed. NOTE: There is an alternate plot version available in the code to produce an mp4 instead of html video (though it loses some of the key functionality). Momin Malik has posted a version of that to [YouTube](https://www.youtube.com/watch?v=7KJN94LritA).

## 03_Viz_Only.html
This file is only the dynamic visualization (Figure 1) as an embeddable html file. 

## License
Shield: [![CC BY-SA 4.0][cc-by-sa-shield]][cc-by-sa]

This work is licensed under a
[Creative Commons Attribution-ShareAlike 4.0 International License][cc-by-sa].

[![CC BY-SA 4.0][cc-by-sa-image]][cc-by-sa]

[cc-by-sa]: http://creativecommons.org/licenses/by-sa/4.0/
[cc-by-sa-image]: https://licensebuttons.net/l/by-sa/4.0/88x31.png
[cc-by-sa-shield]: https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg
