#######################################################
# This file produces the video of an SABM set of simulated chains.
# It relies on one sub-script, which is called individually (see "source").
# author: jimi adams
# last updated: 2018-09-13
#######################################################

#######################################################
### First, we run the model that will be used.
setwd("/Users/jimiadams/Dropbox/SABM Viz/Socius") # MacBook
# setwd("C:/Users/jimia/Dropbox/SABM Viz/Socius") # PC
source("01_Model & Sim.R")     
# df is the dataframe of output micro timesteps 
#######################################################


#######################################################
### Next, initialize a network that corresponds to T=0, add some vertex attributes.
init <- network(s501,matrix.type="adjacency",directed=T)
set.vertex.attribute(init, "smoke", s50s[,1])
set.vertex.attribute(init, "pid", c(1:50))

### Some object-class conversions to the passed df, because their types got erased.
df$V2 <- as.numeric(df$V2)
df$V4 <- as.numeric(df$V4)
df$V5 <- as.numeric(df$V5)
df$V6 <- as.numeric(df$V6)

### Because the nodes are indexed from 0, changing their IDs (now 1-50)
df$V4 <- df$V4 + 1
df$V5[which(df$V2==0)] <- df$V5[which(df$V2==0)] + 1 
    # only change for network steps (retain 0s if behavior)

### Generating a matrix of network edge toggles
df$id <- as.numeric(row.names(df)) # to get micro time step
toggles <- df[,c(12,4,5)][which (df$V2==0 & df$V11==F),] 
    # 12 is the time step, (4,5) is head, tail,  
    # V2=0 is for network evaluations, V11=F is for CHANGES
colnames(toggles) <- c("time", "tail", "head")

### Generating a matrix of behavior changes
beh <- df[,c(12,4,6)][which(df$V2==1 & df$V11==F),]
colnames(beh) <- c("time", "node", "change")
#######################################################

#######################################################
### Initializing the dynamic network object and some visual options to make that easily spotted.
library(networkDynamic)
s50d <-networkDynamic(base.net=init, edge.toggles=toggles, create.TEAs=T)

### Highlighting the node with the opportunity to make a choice
# Initializing some plotting options for that highlighting 
# (node color currently, also tried thickness and shading of vertex border)
activate.vertex.attribute(s50d, "halo", "gray90", onset=0, terminus=Inf)
#activate.vertex.attribute(s50d, "growth", 1, onset=0, terminus=Inf)
#activate.vertex.attribute(s50d, "thick", 1, onset=0, terminus=Inf)
for (i in 1:nrow(df)){
  t <- df$id[i] # I'm just trying to keep the replace statement from getting unweildy.
  n <- df$V4[i]
  activate.vertex.attribute(s50d, "halo", "red", onset=t-1, terminus=t, v=n)
#  activate.vertex.attribute(s50d, "growth", 2, onset=t-1, terminus=t, v=n)
#  activate.vertex.attribute(s50d, "thick", 5, onset=t-1, terminus=t, v=n)
}

### Adding the behavior changes 
activate.vertex.attribute(s50d, "smoke", s50s[,1])
# for some reason the values from "init" aren't sticking w/ the way I assign updates, so re-attaching.
activate.vertex.attribute(s50d, "size", s50s[,1]/2) #making size relative to smoking status

for (i in 1:nrow(beh)){
  t <- beh$time[i] # I'm just trying to keep the replace statement from getting unweildy.
  n <- beh$node[i]
  d <- beh$change[i]
  curr <- get.vertex.attribute.active(s50d,'smoke',at=(t-1))[n]
  
  # This is the reassignment: current value (curr) + change (d) taking effect at onset (t) for node (n)
  activate.vertex.attribute(s50d, "smoke", curr+d, onset=t, terminus=Inf, v=n)
  # And re-setting size accordingly
  activate.vertex.attribute(s50d, "size", get.vertex.attribute.active(s50d, "smoke", at=t)[n]/2, onset=t, terminus=Inf, v=n)
}
#######################################################

#######################################################
# NOTE: This block of code is adding additional information to the visual, but can be dropped w/o much loss.
### Carrying some of the information from above in a shareable way, to add as a clickable option.
# These are the empty "bins" into which actor's decisions will be placed.
activate.vertex.attribute(s50d, "fn", NA) # Which choice is to be evaluated
activate.vertex.attribute(s50d, "choice", NA) # The result of that evaluation

for (i in 1:nrow(df)){
  t <- df$id[i]
  n <- df$V4[i]

  # Who has the opportinity to make which choice in this time slice.
  activate.vertex.attribute(s50d, "fn", df$V1[i], onset=t-1, terminus=t+1, v=n)

  # Providing meaningful labels for the choices they make.
  # Those evaluations that result in no change first.
  if(df$V11[i]==T){activate.vertex.attribute(s50d, "choice", "no change", onset=t-1, terminus=t+1, v=n)}
  # Now evaluations that result in a change.
  if(df$V11[i]==F){
    if(df$V1[i]=="Behavior"){
      if(beh$change[which(beh$time==i)]==1){activate.vertex.attribute(s50d, "choice", "increase", onset=t-1, terminus=t+1, v=n)}
      if(beh$change[which(beh$time==i)]==-1){activate.vertex.attribute(s50d, "choice", "decrease", onset=t-1, terminus=t+1, v=n)}
    }
    # Network ties are a little more complicated, because all we were feeding is a set of toggles.
    if(df$V1[i]=="Network"){
      alt <- toggles$head[which(toggles$time==i)]
      if(alt %in% get.neighborhood.active(s50d, n, at=i-1, type="out")==T){activate.vertex.attribute(s50d, "choice", paste("Drop tie to", alt, sep=" "), onset=t-1, terminus=t+1, v=n)}
      if(alt %in% get.neighborhood.active(s50d, n, at=i-1, type="out")==F){activate.vertex.attribute(s50d, "choice", paste("Add tie to", alt, sep=" "), onset=t-1, terminus=t+1, v=n)}
    }
  }
}
#######################################################

#######################################################
### Plotting the network movie
library(ndtv)
palette(c("white", "gray75", "black"))

### This generates the layouts conforming to each interval (be sure to change the end back)
slice.par <- list(interval=1, aggregate.dur=1, start=0, end=nrow(df), rule="all")
compute.animation(s50d, slice.par=slice.par, displayisolates=T)
render.par=list(tween.frames=5, show.time=T)

### This generates the video from that dynamic layout.
# as html
render.d3movie(s50d,filename='SABM.html',
               launchBrowser=FALSE,
               d3.options=list(animationDuration=1000),
               edge.col="gray75",
               vertex.col="halo", vertex.sides=50, vertex.cex="size", 
               displaylabels=T, label.col="black", label.cex=.5,
               main="",
               ani.options=list(interval=.1),  
               script.type='embedded', 
               vertex.tooltip = function(slice){paste('ID:',slice%v%'vertex.names','<br>',
                                                      'Choice:', slice%v%'fn','<br>',
                                                      'Decision:', slice%v%'choice' )})

# as mp4
# saveVideo(render.animation(s50d,
#                            edge.col="black", arrowhead.cex=.5,
#                            vertex.border = "gray50", vertex.col="smoke", vertex.sides=50,
#                            displaylabels=T, label.col="gray75", label.cex=.5,
#                            displayisolates=T, ani.options=list(interval=.1),
#                            main="SABM Micro Time Steps", render.cache='none'),
#           video.name="SABM_viz.mp4")

