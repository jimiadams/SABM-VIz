#######################################################
# This file produces the model runs from a tutorial example of an SABM.
# The model is adapted from an example developed by Christian Steglich.

# The script produces model output (myResults), and the simulation chains for 1 selected run (df).
        # NOTE: Interpretation of the "chains" elements are provided at the bottom of this file.

# author: David Schaefer
# last updated: 2018-08-27
#######################################################

library(RSiena)
library(sna)
# install.packages("lattice")
library(lattice)  # for plotting

# specify and run a model using the s50 data (included in RSiena > 1.2-12)
friends <- sienaDependent(array(c(s501,s502,s503),dim=c(dim(s501),3)))
smoke <- sienaDependent(s50s,type="behavior")

myDataSmoke <- sienaDataCreate(friends,smoke)
myEffects <- getEffects(myDataSmoke)

# selection effects
myEffects <- includeEffects(myEffects, recip, transTrip, transRecTrip, inPopSqrt, name="friends")
myEffects <- includeEffects(myEffects, egoX, altX, simX, interaction1="smoke", name="friends")

# behavior change effect: peer influence
myEffects <- includeEffects(myEffects, avSim, interaction1="friends", name="smoke")

# specify the estimation algorithm
modelOptions <- sienaAlgorithmCreate(
  projname='SIENA smoke 180827', MaxDegree=c(friends=6), nsub=5, 
  doubleAveraging=0, diagonalize=.2, seed=840428)  # seed only for reproducability of example

# estimate the model
myResults <- siena07(modelOptions, data=myDataSmoke,
	effects= myEffects, batch=F, verbose=F,
	returnDeps=T, returnChains=T)

# examine estimated model
myResults

# save the full answer object 
saveRDS(myResults, 'myResults180827.RDS')
myResults <- readRDS('myResults180827.RDS') # make sure the RSiena library opened already

# examine the 
class(myResults$chain)
length(myResults$chain)   # list of 1000 simulation runs

# extract the 50th simulation run
chainNum <- 50
datChain <- t(matrix(unlist(myResults$chain[[chainNum]][[1]][[1]]), 
      nc=length(myResults$chain[[chainNum]][[1]][[1]]))) 
# From the manual - "The chain has the structure chain[[run]][[depvar]][[period]][[ministep]]."
# So this means, in the above, we are pulling the chains for the first run, from the modeled
# changes between the 1st and 2nd waves in this particular call.
dim(datChain)  # change opportunities (microsteps); 11 values stored for each
df <- as.data.frame(datChain, stringsAsFactors = F)

### Interpretation of the columns on the outputted df - 

# 1 - network or behavior function 
# 2 - same as 1, denoted as 0/1 
# 3 - same as 1/2, denoted using varname 
# 4 - ego ID (starting @0) 
# 5 - if network function - alter ID (starting @0) for changes 
                            # ego ID for no change 
      # 0 if behavior function 
# 6 - 0 if network 
      # -1, 0, 1 for change in behavior level behavior 
# Our aims don't make use of columns 7-10

# 11 - Designates stability (i.e., “True” means no change, “False” means change) 

