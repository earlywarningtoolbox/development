#install.packages("earlywarnings")
#library(devtools); install_github(repo = "earlywarnings-R", username = "earlywarningtoolbox", subdir = "earlywarnings", ref = "master")
library(earlywarnings)

source("qda_ews.R")
source("generic_RShiny.R")
source("sensitivity_RShiny.R")
source("potential_RShiny.R")

load("climate_data.rda")
load("fold_simulated_data.rda")

# Real climate data
#YD2PB_grayscale$time
#timeseries <- YD2PB_grayscale$x

# Simulated data
timeseries <- foldbif$y

# Here you can manipulate the following arguments:
# winsize is the size of the rolling window expressed as percentage of the timeseries length (must be numeric between 0 and 100). Default is 50\%.
# detrending the timeseries can be detrended/filtered prior to analysis. There are four options: gaussian, linear and first-differencing.
# bandwidth is the bandwidth used for the Gaussian kernel when gaussian filtering is applied. It is expressed as percentage of the timeseries length (must be numeric between 0 and 100).
# cutoff to estimate minima and maxima in the potential
# logtransform logical. If TRUE data are logtransformed prior to analysis as log(X+1). Default is FALSE.
# interpolate logical. If TRUE linear interpolation is applied to produce a timeseries of equal length as the original. Default is FALSE (assumes there are no gaps in the timeseries).

q <- qda_ews(timeseries, winsize=50, detrending="gaussian", bandwidth=NULL, cutoff=0.5, logtransform=FALSE, interpolate=FALSE)

