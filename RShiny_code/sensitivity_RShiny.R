# sensitivity_Rshiny for estimating sensitivity for variance and autocorrelation
# 26 Feb 2013

sensitivity_RShiny<-function(timeseries,winsizerange=c(25,75),incrwinsize=25,detrending=c("no","gaussian","linear","first-diff"),bandwidthrange=c(5,100),incrbandwidth=20,logtransform=FALSE,interpolate=FALSE){

	  timeseries<-data.matrix(timeseries)
    if (dim(timeseries)[2]==1){
		Y=timeseries
		timeindex=1:dim(timeseries)[1]
		}else if(dim(timeseries)[2]==2){
		Y<-timeseries[,2]
		timeindex<-timeseries[,1]
		}else{
		warning("not right format of timeseries input")
		}
		
	# Interpolation
	if (interpolate){
		YY<-approx(timeindex,Y,n=length(Y),method="linear")
		Y<-YY$y
		}else{
		Y<-Y}
			
	# Log-transformation
	if (logtransform){
		Y<-log(Y+1)}

	# Determine the step increases in rolling windowsize
	incrtw<-incrwinsize
	tw<-seq(floor(winsizerange[1]*length(Y)/100),floor(winsizerange[2]*length(Y)/100),by=incrtw)
	twcol<-length(tw)
	low<-6
		
		# Detrending	
	detrending<-match.arg(detrending)	
	if (detrending=="gaussian"){
		incrbw<-incrbandwidth
		width<-seq(floor(bandwidthrange[1]*length(Y)/100),floor(bandwidthrange[2]*length(Y)/100),by=incrbw)
		bwrow<-length(width)
		# Create matrix to store Kendall trend statistics
		Ktauestind_ar1<-matrix(,bwrow,twcol)
		Ktauestind_var<-matrix(,bwrow,twcol)
			# Estimation
			for (wi in 1:(length(width))){
					width1<-width[wi]
					smYY<-ksmooth(timeindex,Y,kernel=c("normal"), bandwidth=width1, range.x=range(timeindex),n.points=length(timeindex))
					nsmY<-Y-smYY$y
				for (ti in 1:length(tw)){	
					tw1<-tw[ti]
					# Rearrange data for indicator calculation
					omw1<-length(nsmY)-tw1+1 ##number of overlapping moving windows
					high<-omw1
					nMR1<-matrix(data=NA,nrow=tw1,ncol=omw1)
						for (i in 1:omw1){
				   			Ytw<-nsmY[i:(i+tw1-1)]
			       			nMR1[,i]<-Ytw}
			       			# Estimate indicator			
							indic_ar1<-apply(nMR1,2,function(x){nAR1<-ar.ols(x,aic= FALSE, order.max=1,dmean=FALSE,intercept=FALSE)
							nAR1$ar})
							indic_var<-apply(nMR1,2,var)
							
				# Calculate trend statistics
				timevec<-seq(1,length(indic_ar1))
				Kt_ar1<-cor.test(timevec,indic_ar1,alternative=c("two.sided"),method=c("kendall"),conf.level=0.95)
				Ktauestind_ar1[wi,ti]<-Kt_ar1$estimate
          
					Kt_var<-cor.test(timevec,indic_var,alternative=c("two.sided"),method=c("kendall"),conf.level=0.95)
					Ktauestind_var[wi,ti]<-Kt_var$estimate
					
				}
				}				
		# Plot
		layout(matrix(1:4,2,2))
		par(font.main=10,mar=(c(4.6,3.5,0.5,2)+0.2),mgp=c(2,1,0),oma=c(0.5,0.5,2,0),cex.axis=0.8,cex.lab=0.8,cex.main=0.8)
    
		#ramp <- colorRamp(c("blue", "red"))
		#colpal=rgb( ramp(seq(0, 1, length = 40)), max = 255)
		#palette(rainbow(n, s = 1, v = 1, start =  max(1,n - 1)/n, end = 0, alpha = 1))
		fields::image.plot(width,tw,Ktauestind_ar1,zlim=c(-1,1),xlab="filtering bandwidth",ylab="rolling window size",main="trend estimate",log="y",nlevel=20,col=rainbow(20))
		ind=which(Ktauestind_ar1==max(Ktauestind_ar1),arr.ind=TRUE)
		lines(width[ind[1]],tw[ind[2]],type="p",cex=1.2,pch=17,col="black")
		hist(Ktauestind_ar1,breaks=12,col="green",main=NULL, xlab="trend estimate", ylab="occurence",border="black",xlim=c(-1,1))
		fields::image.plot(width,tw,Ktauestind_var,zlim=c(-1,1),xlab="filtering bandwidth",ylab="rolling window size",main="trend estimate",log="y",nlevel=20,col=rainbow(20))
		lines(width[ind[1]],tw[ind[2]],type="p",cex=1.2,pch=17,col="black")
		ind=which(Ktauestind_var==max(Ktauestind_var),arr.ind=TRUE)
		hist(Ktauestind_var,breaks=12,col="blue",main=NULL, xlab="trend estimate", ylab="occurence", border="black",xlim=c(-1,1))
		mtext("Autocorrelation",side=3,line=0.2, outer=TRUE)
		mtext("Variance",line=-12, at=0.5, outer=TRUE)
		
		# Output
		#out<-data.frame(Ktauestind)
		#colnames(out)<-tw
    #rownames(out)<-width
		#return(out)		
		return(detrending)
    
	}else if(detrending=="linear"){
		nsmY<-resid(lm(Y~timeindex))
	}else if(detrending=="first-diff"){
		nsmY<-diff(Y)
	}else if(detrending=="no"){
		nsmY<-Y
	}
	
	# Create matrix to store Kendall trend statistics
	Ktauestind_ar1<-matrix(,twcol,1)
	Ktauestind_var<-matrix(,twcol,1)
		
for (ti in 1:length(tw)){	
					tw1<-tw[ti]
					# Rearrange data for indicator calculation
					omw1<-length(nsmY)-tw1+1 ##number of overlapping moving windows
					high=omw1
					nMR1<-matrix(data=NA,nrow=tw1,ncol=omw1)
						for (i in 1:omw1){
				   			Ytw<-nsmY[i:(i+tw1-1)]
			       			nMR1[,i]<-Ytw}
			       			# Estimate indicator
							indic_ar1<-apply(nMR1,2,function(x){nAR1<-ar.ols(x,aic= FALSE, order.max=1,dmean=FALSE,intercept=FALSE)
							nAR1$ar})
							
							indic_var<-apply(nMR1,2,sd)
				# Calculate trend statistics
				timevec<-seq(1,length(indic_ar1))
				Kt_ar1<-cor.test(timevec,indic_ar1,alternative=c("two.sided"),method=c("kendall"),conf.level=0.95)
				Ktauestind_ar1[ti]<-Kt_ar1$estimate
					Kt_var<-cor.test(timevec,indic_var,alternative=c("two.sided"),method=c("kendall"),conf.level=0.95)
					Ktauestind_var[ti]<-Kt_var$estimate

				}
		# Plotting
		dev.new()
		layout(matrix(1:4,2,2))
	  par(font.main=10,mar=(c(4.6,3.2,0.5,2)+0.2),mgp=c(2,1,0),oma=c(0.5,0.5,2,0),cex.axis=0.8,cex.lab=0.8,cex.main=0.8)
		plot(tw,Ktauestind_ar1,type="l",log="x",xlab="rolling window size",ylab="trend estimate")
		hist(Ktauestind_ar1,breaks=12,col="green", xlab="trend estimate", ylab="occurence",border="black",main=NULL)
		plot(tw,Ktauestind_var,type="l",xlab="rolling window size",log="x",ylab="trend estimate")
		hist(Ktauestind_var,breaks=12,col="blue", xlab="trend estimate",main=NULL, ylab="occurence",border="black")
		mtext("Autocorrelation",side=3,line=0.2, outer=TRUE)
	  mtext("Variance",line=-12, at=0.5, outer=TRUE)
		
		# Output
# 		out<-data.frame(tw,Ktauestind,Ktaupind)
# 		colnames(out)<-c("rolling window","Kendall tau estimate","Kendall tau p-value")
	  #out<-data.frame(Ktauestind)
    #rownames(out)<-tw
		#return(out)
}