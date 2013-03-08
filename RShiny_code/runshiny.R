library(shiny)
library(ggplot2)
library(earlywarnings)

source("qda_ews.R")
source("generic_RShiny.R")
source("sensitivity_RShiny.R")
source("potential_RShiny.R")

#mydata <- diamonds
load("fold_simulated_data.rda") # foldbif (y)
#mydata <- foldbif
timeseries <- foldbif$y
#load("climate_data.rda") # YD2PB_grayscale (time, x)

# Here you can manipulate the following arguments:
# winsize is the size of the rolling window expressed as percentage of the timeseries length (must be numeric between 0 and 100). Default is 50\%.
# detrending the timeseries can be detrended/filtered prior to analysis. There are four options: gaussian, linear and first-differencing.
# bandwidth is the bandwidth used for the Gaussian kernel when gaussian filtering is applied. It is expressed as percentage of the timeseries length (must be numeric between 0 and 100).
# cutoff to estimate minima and maxima in the potential
# logtransform logical. If TRUE data are logtransformed prior to analysis as log(X+1). Default is FALSE.
# interpolate logical. If TRUE linear interpolation is applied to produce a timeseries of equal length as the original. Default is FALSE (assumes there are no gaps in the timeseries).

# Run locally
shiny::runApp("demo")

# Run from Github
#shiny::runGitHub(repo = "development", username = 'earlywarningtoolbox', subdir = "RShiny_code/demo/")

#shiny::runGitHub(repo = "development", username = 'earlywarningtoolbox', subdir = "RShiny_code/shiny-helloworld/")
