## Shiny examples

Run in R: source("runshiny.R") to execute the working version.

### Description of input arguments

* winsize: size of the sliding window expressed as percentage of the timeseries length (numeric between 0 and 100). 
* detrending: the timeseries can be detrended/filtered prior to analysis. There are four options: gaussian, linear and first-differencing.
* bandwidth: the bandwidth used for the Gaussian kernel when gaussian filtering is applied. It is expressed as percentage of the timeseries length (numeric between 0 and 100).
* cutoff:  for minima and maxima visualization in potential analysis
* logtransform logical. If TRUE data are logtransformed prior to analysis as log(X+1). Default is FALSE.
* interpolate logical. If TRUE linear interpolation is applied to produce a timeseries of equal length as the original. Default is FALSE (assumes there are no gaps in the timeseries).

