print("Load functions")
source("wrapper_RShiny.R")


print("Load data")
load("climate_data.rda")
load("fold_simulated_data.rda")

print("Pick data")

# Real climate data
#YD2PB_grayscale$time
timeseries <- data.matrix(YD2PB_grayscale$x)

# Simulated data
#timeseries <- data.matrix(foldbif$y)


print("Indicator trend analysis")
g <- generic_RShiny(timeseries,winsize=50,detrending=c("no","gaussian","linear","first-diff"),bandwidth=NULL,logtransform=FALSE,interpolate=FALSE,AR_n=FALSE,powerspectrum=FALSE)

print("Trend significance analysis")
s <- surrogates_RShiny(timeseries,winsize=50,detrending=c("no","gaussian","linear","first-diff"),bandwidth=NULL,boots=100,s_level=0.05,logtransform=FALSE,interpolate=FALSE)

print("Potential analysis")
p <- movpotential_RShiny(timeseries, param = NULL, bw = -1, detection.threshold = 0.002, std = 1, grid.size = 50, plot.cutoff = 0.5)
p$plot

