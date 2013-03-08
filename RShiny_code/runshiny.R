library(shiny)
library(ggplot2)
#library(devtools); install_github(repo = "earlywarnings-R", username = "earlywarningtoolbox", subdir = "earlywarnings", ref = "master")
library(earlywarnings)

source("qda_ews.R")
source("generic_RShiny.R")
source("sensitivity_RShiny.R")
source("potential_RShiny.R")

# Simulated data
#load("fold_simulated_data.rda") # foldbif (y)
#names(foldbif) <- "obs"
#write.csv(foldbif, file = "simulateddata.csv", quote = F, row.names = F)
mydata <- read.csv("simulateddata.csv")

# Real data
#load("climate_data.rda") 
#timeseries <- YD2PB_grayscale$time
#param <- YD2PB_grayscale$x
#names(YD2PB_grayscale) <- c("time", "obs")
#write.csv(YD2PB_grayscale, file = "climatedata.csv", quote = F, row.names = F)
mydata <- read.csv("climatedata.csv")


# Run locally
shiny::runApp("demo")

