#' Description: Quick Detection Analysis for Generic Early Warning Signals
#'
#' \code{qda_ews} is used to estimate autocorrelation, variance within rolling windows along a timeseries, test the sensitivity in their trends, and reconstruct the potential landscape of the timeseries
#'
# Details:
#' see ref below
#'
# Arguments:
#'    @param timeseries a numeric vector of the observed univariate timeseries values or a numeric matrix where the first column represents the time index and the second the observed timeseries values. Use vectors/matrices with headings.
#'    @param winsize is the size of the rolling window expressed as percentage of the timeseries length (must be numeric between 0 and 100). Default is 50\%.
#'    @param detrending the timeseries can be detrended/filtered prior to analysis. There are four options: \code{gaussian} filtering, \code{linear} detrending and \code{first-differencing}. Default is \code{no} detrending.
#'    @param bandwidth is the bandwidth used for the Gaussian kernel when gaussian filtering is applied. It is expressed as percentage of the timeseries length (must be numeric between 0 and 100). Alternatively it can be given by the bandwidth selector \code{\link{bw.nrd0}} (Default).
#    @param incrwinsize increments the rolling window size (must be numeric between 0 and 100). Default is 25.
#'    @param boots the number of surrogate data. Default is 100.
#'    @param s_level significance level. Default is 0.05.
#    @param incrbandwidth is the size to increment the bandwidth used for the Gaussian kernel when gaussian filtering is applied. It is expressed as percentage of the timeseries length (must be numeric between 0 and 100). Default is 20.
#'    @param cutoff the cuttof value to estimate minima and maxima in the potential
#'    @param logtransform logical. If TRUE data are logtransformed prior to analysis as log(X+1). Default is FALSE.
#'    @param interpolate logical. If TRUE linear interpolation is applied to produce a timeseries of equal length as the original. Default is FALSE (assumes there are no gaps in the timeseries).
 
#' 
# Returns:
#' \code{qda_ews} returns three plots. The first plot contains the original data, the detrending/filtering applied and the residuals (if selected), autocorrelation and variance. For each statistic trends are estimated by the nonparametric Kendall tau correlation.  The second plot, returns a plot with the Kendall tau estimates for a range of rolling window sizes used, together with a histogram of the distributions of the statistic for autocorrelation and variance. When \code{gaussian filtering} is chosen, a contour plot is produced for the Kendall tau estimates for the range of both rolling window sizes and bandwidth used. A reverse triangle indicates the combination of the two parameters for which the Kendall tau was the highest The third plot is reconstructed potential landscape in 2D.
#'  
#' @export
#' 
#' @author Vasilis Dakos \email{vasilis.dakos@@gmail.com}
#' @references
#' Dakos, V., et al (2012)."Methods for Detecting Early Warnings of Critical Transitions in Time Series Illustrated Using Simulated Ecological Data." \emph{PLoS ONE} 7(7): e41010. doi:10.1371/journal.pone.0041010 
#' @seealso \code{\link{generic_ews}}; \code{\link{ddjnonparam_ews}}; \code{\link{bdstest_ews}}; \code{\link{sensitivity_ews}}; \code{\link{surrogates_ews}}; \code{\link{ch_ews}}; \code{\link{movpotential_ews}}; \code{\link{livpotential_ews}}; 
# '
# ' @examples 
# ' data(foldbif)
# ' qda_ews(foldbif, winsize = 50, detrending="gaussian", bandwidth=NULL, boots = 100, s_level = 0.05, cutoff=0.5, logtransform=FALSE, interpolate=FALSE)
# ' @keywords early-warning

#'  @author Vasilis Dakos, Leo Lahti, March 1, 2013

qda_ews <- function(timeseries, winsize = 50, detrending=c("no","gaussian","linear","first-diff"), bandwidth=NULL, boots = 100, s_level = 0.05, cutoff=0.05, logtransform=FALSE, interpolate=FALSE, analysis = c("generic", "potential")){
  
  timeseries <- data.matrix(timeseries)
  
  if (analysis == "generic") { 
    message("Generic Indicators")
    p <- generic_RShiny(timeseries,winsize,detrending,bandwidth,logtransform,interpolate,AR_n=FALSE,powerspectrum=FALSE)
  } else if (analysis == "potential") { 

    message("Potential Analysis")
    param <- seq(from = 1, to = length(timeseries[,1]), by = 1)
    if (ncol(timeseries)==2){
      dataset <- timeseries[,2]
    } else {
      dataset <- timeseries[,1]
    }
    p <- movpotential_ews(dataset, param, sdwindow = NULL, bw = -1, minparam = NULL, maxparam = NULL, npoints = 50, thres = 0.002, std = 1, grid.size = 200, cutoff)
    print(p)
  }

#   print("Sensitivity of trends")
#   s <- sensitivity_RShiny(timeseries,winsizerange=c(25,75),incrwinsize,detrending=detrending, bandwidthrange=c(5,100),incrbandwidth,logtransform=FALSE,interpolate=FALSE)
#   
#   print("Significance of trends")
#   s <- surrogates_RShiny(timeseries,winsize,detrending,bandwidth,boots,s_level,logtransform,interpolate)
  
  p

}