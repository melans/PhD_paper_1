if(!require(hydroGOF))install.packages("hydroGOF");
# options(warn=-1);

# ((floor(month/3)%%4)+1)
# 1- W : Winter (Dec-Jan-Feb)
# 2- S : spring (Mar-Apr-May)
# 3- H : summer (Jun-July-Aug)
# 4- F : fall (Sep-Oct-Nov)


args <- commandArgs(TRUE);# print (args);# q();
startDT <- as.numeric(args[1]);
endDT <- as.numeric(args[2]);
obs <- args[3];
mdl1 <- args[4];
mdl2 <- args[5];
epsilon <- as.numeric(args[6]);
doCli <- as.numeric(args[7]);
training <- (endDT-startDT+1)*2/3;

m2s <- function(m){
	return(floor(m/3)%%4+1)
}

obs <- read.table(obs);#, row.names=c("year,month,q"));
names(obs) <- c('Year','Month','Observed');
obs <- obs[obs$Year >= startDT & obs$Year <= endDT,];
obs$Season <- m2s(obs$Month)
obs <- obs[,c(1,2,4,3)]
# obs
obsT <- obs[obs$Year <= startDT+training-1,];		# observed - training
obsV <- obs[obs$Year > startDT+training-1,];			# observed - validation
# obsT$Season;
# obsV;

clim <- data.frame();
for(season in unique(obsT$Season))
	clim <- rbind(clim,c(season,mean(obsT[obsT$Season == season,]$Observed)));
names(clim) <- c('Season','Avg');
# clim;

# clim <- data.frame();
# for(month in unique(obsT$Month))
# 	clim <- rbind(clim,c(month,mean(obsT[obsT$Month == month,3])));
# names(clim) <- c('Month','Avg');
# clim[2,];
# m="01";
L=1;

# obsT[obsT$Month==1,3];
m1 <- data.frame();
m2 <- data.frame();

if(1){
	for(m in 1:12){
		oT <- obsT[obsT$Month==m,]$Observed;
		oV <- obsV[obsV$Month==m,]$Observed;

		mm <- sprintf("%02d",m);

		model1 <- read.table(paste(mdl1,mm,L,"txt",sep="."), skip=6);
		model1$Month <- m;	# add months
		model1$Season <- m2s(m);	#	add seasons
		model1 <- model1[,c(1,3,4,2)];	#	sort the fields
		names(model1) <- c('Year','Month','Season','M1');	#	add header names
		model1$M1 <- exp(model1$M1)-epsilon;	#
		m1 <- rbind(m1,model1);

		model2 <- read.table(paste(mdl2,mm,L,"txt",sep="."), skip=6);
		model2$Month <- m;	# add months
		model2$Season <- m2s(m);	#	add seasons
		model2 <- model2[,c(1,3,4,2)];	#	sort the fields
		names(model2) <- c('Year','Month','Season','M2');	#	add header names
		model2$M2 <- exp(model2$M2)-epsilon;	#
		m2 <- rbind(m2,model2);
	}
	print(m1);
	print(m2);
}






if(0){
	print("Season")
	if(doCli){
		print("Year,Observed,ECHAM4p5,W1,wECHAM4p5,CFSv2,W2,wCFSv2,Climatology,W3,wClimatology,Combination,R2,MSSS");
	}else{
		print("Year,Observed,ECHAM4p5,W1,wECHAM4p5,CFSv2,W2,wCFSv2,Combination,R2,MSSS");
	}

	for(m in 1:12){
		oT <- obsT[obsT$Month==m,]$Observed;
		oV <- obsV[obsV$Month==m,]$Observed;
		# print(paste(oT,oV))
		mm <- sprintf("%02d",m);

		m1 <- paste(mdl1,mm,L,"txt",sep=".");
		m1 <- read.table(m1,skip=6);
		names(m1) <- c('Year','M1');
		m1$M1 <- exp(m1$M1)-epsilon;	#	V2 = value 2 = prediction
		m1T <- m1[m1$Year <= startDT+training-1,];		# model 1 - training
		m1V <- m1[m1$Year >= startDT+training,];			# model 1 - validation

		m2 <- paste(mdl2,mm,L,"txt",sep=".");
		m2 <- read.table(m2,skip=6);#, row.names=c("year,month,q"));
		names(m2) <- c('Year','M2');
		m2$M2 <- exp(m2$M2)-epsilon;
		m2T <- m2[m2$Year <= startDT+training-1,];		# model 2 - training
		m2V <- m2[m2$Year >= startDT+training,];			# model 2 - validation

		# print(m1V$M1)
		# m1=m1T$M1;
		# m2=m2T$M2;
		# print(oT$Observed);
		# Validation

		if(doCli){
			clT=rep(clim[m,2], each=training);
			clV=rep(clim[m,2], each=9);
			# print(cl)
			d <- (rmse(c(oT),c(m1T$M1))^-1 + rmse(c(oT),c(m2T$M2))^-1 + rmse(c(oT),c(clT))^-1)^-1;
			w1 <- d/rmse(c(oT),c(m1T$M1));
			w2 <- d/rmse(c(oT),c(m2T$M2));
			wcl <- d/rmse(c(oT),c(clT));
			# m1V$V2 <- m1V$V2*w1;
			# m2V$V2 <- m2V$V2*w2;
			print(mm);
			comb <- m1V$M1*w1 + m2V$M2*w2 + clV*wcl;
			# print(comb);
			# print(clT);
			# oV;
			# comp;
			r2 <- cor(c(oV),c(comb),use="pairwise.complete.obs",method="spearman")^2;
			ms <- 1-(sum((oV-comb)^2)/sum((comb-clV)^2))^2
			print(paste(m1V$Year, oV, m1V$M1, w1, m1V$M1*w1, m2V$M2, w2, m2V$M2*w2, clV, wcl, clV*wcl, comb, r2, ms, sep=","));
			# print(paste(m1V$Year, oV, m1V$M1, w1, m1V$M1*w1, m2V$M2, w2, m2V$M2*w2, cl, wcl, cl*wcl, comb, sep=","));
			# print(paste(mm,w1, w2, wcl,sep=","));
		}else{
			d <- (rmse(oT,m1)^-1 + rmse(oT,m2)^-1)^-1;
			w1 <- d/rmse(oT,m1);
			w2 <- d/rmse(oT,m2);
			print(mm);
			print(paste(m1V$Year, oV, m1V$M1, w1, m1V$M1*w1, m2V$M2, w2, m2V$M2*w2, m1V$V2*w1 + m2V$V2*w2,sep=","));
		}

	}
}
