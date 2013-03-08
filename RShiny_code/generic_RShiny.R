# generic_Rshiny for estimating only AR1 and Variance in moving windows with various options for pretreating the data
# 26 Feb 2013


generic_RShiny<-function(timeseries,winsize=50,detrending=c("no","gaussian","linear","first-diff"),bandwidth,logtransform,interpolate,AR_n=FALSE,powerspectrum=FALSE){	
	
	require(lmtest)
	require(nortest)
	require(stats)
	require(som)
	require(Kendall)
	require(KernSmooth)
	require(moments)

  #timeseries<-ts(timeseries)
  timeseries<-data.matrix(timeseries) #strict data-types the input data as tseries object for use in later steps
  if (ncol(timeseries) == 1){
		Y=timeseries
		timeindex=1:dim(timeseries)[1]
		}else if(dim(timeseries)[2]==2){
		Y<-timeseries[,2]
		timeindex<-timeseries[,1]
		}else{
		warning("not right format of timeseries input")
		}
		#return(timeindex)
	# Interpolation
	if (interpolate){
		YY<-approx(timeindex,Y,n=length(Y),method="linear")
		Y<-YY$y
		}else{
		Y<-Y}
			
	# Log-transformation
	if (logtransform){
		Y<-log(Y+1)}
	
	# Detrending	
	detrending<-match.arg(detrending)	
	if (detrending=="gaussian"){
		if (is.null(bandwidth)){
			bw<-round(bw.nrd0(timeindex))}else{
			bw<-round(length(Y)*bandwidth/100)}
			smYY<-ksmooth(timeindex,Y,kernel="normal",bandwidth=bw,range.x=range(timeindex),x.points=timeindex)
    if (timeindex[1]>timeindex[length(timeindex)]){
      nsmY<-Y-rev(smYY$y)
      smY<-rev(smYY$y) 
    }else{  	nsmY<-Y-smYY$y
             smY<-smYY$y}
	}else if(detrending=="linear"){
		nsmY<-resid(lm(Y~timeindex))
		smY<-fitted(lm(Y~timeindex))
	}else if(detrending=="first-diff"){
		nsmY<-diff(Y)
		timeindexdiff<-timeindex[1:(length(timeindex)-1)]
	}else if(detrending=="no"){
		smY<-Y
		nsmY<-Y
	}


	# Rearrange data for indicator calculation
	mw<-round(length(Y)*winsize/100)
	omw<-length(nsmY)-mw+1 ##number of moving windows
	low<-6
	high<-omw
	nMR<-matrix(data=NA,nrow=mw,ncol=omw)
	x1<-1:mw
		for (i in 1:omw){ 	 
		Ytw<-nsmY[i:(i+mw-1)]
		nMR[,i]<-Ytw}

	# Calculate indicators
	nARR<-numeric()
	nSD<-numeric()

	nSD<-apply(nMR, 2, sd, na.rm = TRUE)
	for (i in 1:ncol(nMR)){
		nYR<-ar.ols(nMR[,i],aic= FALSE, order.max=1, dmean=FALSE, 		intercept=FALSE)
		nARR[i]<-nYR$ar
	}
	
  nVAR=sqrt(nSD)
  
	# Estimate Kendall trend statistic for indicators
	timevec<-seq(1,length(nARR))
	KtAR<-cor.test(timevec,nARR,alternative=c("two.sided"),method=c("kendall"),conf.level=0.95)
	KtVAR<-cor.test(timevec,nVAR,alternative=c("two.sided"),method=c("kendall"),conf.level=0.95)

	# Plotting
	# Generic Early-Warnings
	#dev.new()
	par(mar=(c(1,2,0.5,2)+0),oma=c(2,2,2,2),mfrow=c(4,1))  
	plot(timeindex,Y,type="l",ylab="",xlab="",xaxt="n",lwd=2,las=1,xlim=c(timeindex[1],timeindex[length(timeindex)]))
	legend("bottomleft","data",,bty = "n")
	if(detrending=="gaussian"){
		lines(timeindex,smY,type="l",ylab="",xlab="",xaxt="n",lwd=2,col=2,las=1,xlim=c(timeindex[1],timeindex[length(timeindex)]))
	}
	if(detrending=="no"){
		plot(c(0,1),c(0,1),ylab="",xlab="",yaxt="n",xaxt="n",type="n",las=1)
		text(0.5,0.5,"no detrending - no residuals")
		}else if (detrending=="first-diff"){
		limit<-max(c(max(abs(nsmY))))
		plot(timeindexdiff,nsmY,ylab="",xlab="",type="l",xaxt="n",lwd=2,las=1,ylim=c(-	limit,limit),xlim=c(timeindexdiff[1],timeindexdiff[length(timeindexdiff)]))
		legend("bottomleft","first-differenced",bty = "n")		}else{
		limit<-max(c(max(abs(nsmY))))
		plot(timeindex,nsmY,ylab="",xlab="",type="h",xaxt="n",las=1,lwd=2,ylim=c(-	limit,limit),xlim=c(timeindex[1],timeindex[length(timeindex)]))
		legend("bottomleft","residuals",bty = "n")}
	plot(timeindex[mw:length(nsmY)],nARR,ylab="",xlab="",type="l",xaxt="n",col="green",lwd=2,las=1,xlim=c(timeindex[1],timeindex[length(timeindex)])) #3
	legend("bottomright",paste("trend ",round(KtAR$estimate,digits=3)),bty = "n")
	legend("bottomleft","autocorrelation",bty = "n")
	plot(timeindex[mw:length(nsmY)],nVAR,ylab="",xlab="",type="l",col="blue", lwd=2, las=1,xlim=c(timeindex[1],timeindex[length(timeindex)]))
	legend("bottomright",paste("trend ",round(KtVAR$estimate,digits=3)),bty = "n")
	legend("bottomleft","variance",bty = "n")
	mtext("time",side=1,line=2,cex=0.8)
	mtext("Generic Early-Warnings: Autocorrelation - Variance",side=3,line=0.2, outer=TRUE)#outer=TRUE print on the outer margin
	
  # Output
  out<-data.frame(timeindex[mw:length(nsmY)],nARR,nSD)
  colnames(out)<-c("timeindex","ar1","sd")
  #return(out)

}

