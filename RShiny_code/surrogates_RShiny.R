# surrogates_Rshiny for estimating significance of trends for variance and autocorrelation
# 6 March 2013

surrogates_RShiny<-function(timeseries,winsize=50,detrending=c("no","gaussian","linear","first-diff"),bandwidth=NULL,boots=100,s_level=0.05,logtransform=FALSE,interpolate=FALSE){

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
	
	# Detrending	
	detrending<-match.arg(detrending)	
	if (detrending=="gaussian"){
		if (is.null(bandwidth)){
			bw<-round(bw.nrd0(timeindex))}else{
			bw<-round(length(Y)*bandwidth)/100}
		smYY<-ksmooth(timeindex,Y,kernel=c("normal"), bandwidth=bw, range.x=range(timeindex),n.points=length(timeindex))
		nsmY<-Y-smYY$y
		smY<-smYY$y
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
					mw<-round(length(Y)*winsize)/100
					omw<-length(nsmY)-mw+1
					low<-6
					high<-omw
					nMR<-matrix(data=NA,nrow=mw,ncol=omw)
						for (i in 1:omw){
				   			Ytw<-nsmY[i:(i+mw-1)]
			       			nMR[,i]<-Ytw}
			       			# Estimate indicator
			      			
							indic_ar1<-apply(nMR,2,function(x){nAR1<-ar.ols(x,aic= FALSE, order.max=1,dmean=FALSE,intercept=FALSE)
							nAR1$ar})
							
							indic_var<-apply(nMR,2,var)
						
				# Calculate trend statistics
timevec<-seq(1,length(indic_ar1))
Kt_ar1<-cor.test(timevec,indic_ar1,alternative=c("two.sided"),method=c("kendall"),conf.level=0.95)
Ktauestind_ar1orig<-Kt_ar1$estimate

Kt_var<-cor.test(timevec,indic_var,alternative=c("two.sided"),method=c("kendall"),conf.level=0.95)
Ktauestind_varorig<-Kt_var$estimate

	# Fit ARMA model based on AIC
	arma=matrix(,4,5)
	for (ij in 1:4){
	for (jj in 0:4){
		ARMA<-arima(nsmY, order = c(ij,0,jj),include.mean = FALSE)
		arma[ij,jj+1]=ARMA$aic		
# 		print(paste("AR","MA", "AIC"),quote=FALSE)
# 		print(paste(ij,jj,ARMA$aic),zero.print=".",quote=FALSE)
		}
		}

	# Simulate ARMA(p,q) model fitted on residuals
	ind=which(arma==min(arma),arr.ind=TRUE)
	ARMA<-arima(nsmY, order = c(ind[1],0,ind[2]-1),include.mean = FALSE)

Ktauestind_ar1 <- numeric()
Ktauestind_var <- numeric()

	for (jjj in 1:boots){
	x=arima.sim(n = length(nsmY), list(ar = c(ARMA$coef[1:ind[1]]), ma = c(ARMA$coef[(1+ind[1]):(ind[1]+ind[2]-1)])),sd=sqrt(ARMA$sigma2))

	## Rearrange data for indicator calculation
	nMR1<-matrix(data=NA,nrow=mw,ncol=omw)
	for (i in 1:omw){   
	Ytw<-x[i:(i+mw-1)]
	nMR1[,i]<-Ytw}
	
	# Estimate indicator
	
	indic_ar1<-apply(nMR1,2,function(x){nAR1<-ar.ols(x,aic= FALSE, order.max=1,dmean=FALSE,intercept=FALSE)
                                     nAR1$ar})
	
	indic_var<-apply(nMR1,2,var)

# Calculate trend statistics
timevec<-seq(1,length(indic_ar1))
Kt_ar1<-cor.test(timevec,indic_ar1,alternative=c("two.sided"),method=c("kendall"),conf.level=0.95)
Ktauestind_ar1[jjj]<-Kt_ar1$estimate
	
Kt_var<-cor.test(timevec,indic_var,alternative=c("two.sided"),method=c("kendall"),conf.level=0.95)
Ktauestind_var[jjj]<-Kt_var$estimate

}

	# Estimate probability of false positive
	q_ar1<-sort(Ktauestind_ar1,na.last=NA)
	Kpos_ar1<-max(which(Ktauestind_ar1orig>q_ar1),na.rm=TRUE)
	p<-(boots+1-Kpos_ar1)/boots
	print(paste('significance autocorrelation p = ',p,' estimated from ',boots,' surrogate ARMA timeseries'))

q_var<-sort(Ktauestind_var,na.last=NA)
Kpos_var<-max(which(Ktauestind_varorig>q_var),na.rm=TRUE)
p<-(boots+1-Kpos_var)/boots
print(paste('significance variance p = ',p,' estimated from ',boots,' surrogate ARMA timeseries'))

	# Plotting
  layout(matrix(1:2,1,2))
  par(font.main=10,mar=(c(4.6,3.5,0.5,2)+0.2),mgp=c(2,1,0),oma=c(0.5,0.5,2,0),cex.axis=0.8,cex.lab=0.8,cex.main=0.8)
hist(Ktauestind_ar1,freq=TRUE,nclass=20,xlim=c(-1,1),col="green",main=NULL,xlab="Surrogate trend estimates",ylab="occurrence")#,ylim=c(0,boots))
abline(v=q_ar1[s_level*boots],col="red",lwd=2)
abline(v=q_ar1[(1-s_level)*boots],col="red",lwd=2)
points(Ktauestind_ar1orig,0,pch=21, bg="black", col = "black", cex=4)
title("Autocorrelation",cex.main=1.3)

hist(Ktauestind_var,freq=TRUE,nclass=20,xlim=c(-1,1),col="blue",main=NULL,xlab="Surrogate trend estimates",ylab="occurrence")#,ylim=c(0,boots))
abline(v=q_var[s_level*boots],col="red",lwd=2)
abline(v=q_var[(1-s_level)*boots],col="red",lwd=2)
points(Ktauestind_varorig,0,pch=21, bg="black", col = "black", cex=4)
title("Variance" ,cex.main=1.3)

# # Plot
# layout(matrix(1:4,2,2))
# par(font.main=10,mar=(c(4.6,3.5,0.5,2)+0.2),mgp=c(2,1,0),oma=c(0.5,0.5,2,0),cex.axis=0.8,cex.lab=0.8,cex.main=0.8)
# 
# fields::image.plot(width,tw,Ktauestind_ar1,zlim=c(-1,1),xlab="filtering bandwidth",ylab="rolling window size",main="trend estimate",log="y",nlevel=20,col=rainbow(20))
# ind=which(Ktauestind_ar1==max(Ktauestind_ar1),arr.ind=TRUE)
# lines(width[ind[1]],tw[ind[2]],type="p",cex=1.2,pch=17,col="black")
# hist(Ktauestind_ar1,breaks=12,col="green",main=NULL, xlab="trend estimate", ylab="occurence",border="black",xlim=c(-1,1))
# fields::image.plot(width,tw,Ktauestind_var,zlim=c(-1,1),xlab="filtering bandwidth",ylab="rolling window size",main="trend estimate",log="y",nlevel=20,col=rainbow(20))
# lines(width[ind[1]],tw[ind[2]],type="p",cex=1.2,pch=17,col="black")
# ind=which(Ktauestind_var==max(Ktauestind_var),arr.ind=TRUE)
# hist(Ktauestind_var,breaks=12,col="blue",main=NULL, xlab="trend estimate", ylab="occurence", border="black",xlim=c(-1,1))
# mtext("Autocorrelation",side=3,line=0.2, outer=TRUE)
# mtext("Variance",line=-12, at=0.5, outer=TRUE)

	# Output
# 	out<-data.frame(Ktauestindorig,Ktaupindorig,Ktauestind,Ktaupind,p)
# 	colnames(out)<-c("Kendall tau estimate original","Kendall tau p-value original","Kendall tau estimate surrogates","Kendall tau p-value surrogates","significance p")
# 	return(out)
}