#install.packages("earlywarnings")
#library(devtools); install_github(repo = "earlywarnings-R", username = "earlywarningtoolbox", subdir = "earlywarnings", ref = "master")
library(earlywarnings)

source("qda_RShiny.R")
source("generic_RShiny.R")
source("potential_RShiny.R")
source("surrogates_RShiny.R")

load("climate_data.rda")
load("fold_simulated_data.rda")

# Real climate data
#YD2PB_grayscale$time
timeseries <- YD2PB_grayscale$x

# Simulated data
#timeseries <- foldbif$y

# Here you can manipulate the following arguments:
# winsize is the size of the rolling window expressed as percentage of the timeseries length (must be numeric between 0 and 100). Default is 50\%.
# detrending the timeseries can be detrended/filtered prior to analysis. There are four options: gaussian, linear and first-differencing.
# bandwidth is the bandwidth used for the Gaussian kernel when gaussian filtering is applied. It is expressed as percentage of the timeseries length (must be numeric between 0 and 100).
# boots is the number of surrogate data to generate from fitting an ARMA(p,q) model. Default is 100.
# s_level is significance level. Default is 0.05.
# cutoff to estimate minima and maxima in the potential
# detection.threshold detection threshold for potential minima
# grid.size grid size (for potential analysis)
# logtransform logical. If TRUE data are logtransformed prior to analysis as log(X+1). Default is FALSE.
# interpolate logical. If TRUE linear interpolation is applied to produce a timeseries of equal length as the original. Default is FALSE (assumes there are no gaps in the timeseries).

qda_RShiny(timeseries, param = NULL, winsize = 50, detrending= "gaussian", bandwidth=NULL, boots = 100, s_level = 0.05, cutoff=0.05, detection.threshold = 0.002, grid.size = 50, logtransform=FALSE, interpolate=FALSE, analysis = "Trend significance analysis")