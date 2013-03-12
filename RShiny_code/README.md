## Shiny examples

Run in R: source("runshiny.R") to execute the working version.

### Description of input arguments

* winsize: size of the sliding window expressed as percentage of the timeseries length (numeric between 0 and 100). 
* detrending: the timeseries can be detrended/filtered prior to analysis. There are four options: gaussian, linear and first-differencing.
* bandwidth: the bandwidth used for the Gaussian kernel when gaussian filtering is applied. It is expressed as percentage of the timeseries length (numeric between 0 and 100).
* logtransform logical. If TRUE data are logtransformed prior to analysis as log(X+1). Default is FALSE.
* interpolate logical. If TRUE linear interpolation is applied to produce a timeseries of equal length as the original. Default is FALSE (assumes there are no gaps in the timeseries).
* boots the number of surrogate data to generate from fitting an ARMA(p,q) model. Default is 100.
* s_level significance level. Default is 0.05.
* cutoff the cutoff value to visualize the potential landscape
* detection.threshold detection threshold for potential minima
* grid.size grid size (for potential analysis)
* analysis to perform:"Indicator trend analysis","Trend significance analysis","Potential analysis"
