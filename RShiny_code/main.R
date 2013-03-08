print("Load functions")
source("wrapper_RShiny.R")


print("Load data")
load("climate_data.rda")
load("fold_simulated_data.rda")

print("Pick data")
# Real climate data
#YD2PB_grayscale$time
timeseries <- YD2PB_grayscale$x

# Simulated data
#timeseries <- foldbif$y

print("Generic")
g <- generic_RShiny(timeseries,winsize=50,detrending=c("no","gaussian","linear","first-diff"),bandwidth=NULL,logtransform=FALSE,interpolate=FALSE,AR_n=FALSE,powerspectrum=FALSE)

print("Sensitivity")
s <- sensitivity_RShiny(timeseries,winsizerange=c(25,75),incrwinsize=25,detrending=c("no","gaussian","linear","first-diff"),bandwidthrange=c(5,100),incrbandwidth=20,logtransform=FALSE,interpolate=FALSE)

