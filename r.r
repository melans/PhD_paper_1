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
trn <- (endDT-startDT+1)*2/3;
vld <- (endDT-startDT+1)*1/3;
# print(endDT-vld)
# print(startDT+trn)
m2s <- function(m){return(floor(m/3)%%4+1);}

obs <- read.table(obs);#, row.names=c("year,month,q"));
names(obs) <- c('Year','Month','Observed');
obs <- obs[obs$Year >= startDT & obs$Year <= endDT,];
obs$Season <- m2s(obs$Month)
obs <- obs[,c(1,2,4,3)];
# obs;
obsT <- obs[obs$Year <= endDT-vld,];		# observed - training
obsV <- obs[obs$Year >= startDT+trn,];			# observed - validation
# obsT[2,3];
# obsV;

clim <- data.frame();
for(season in unique(obsT$Season))
	clim <- rbind(clim,c(season,mean(obsT[obsT$Season == season,]$Observed)));
names(clim) <- c('Season','Climatology');

# clim[2,2]
# clT=rep(clim[c(2,3),2], each=trn*3);
# clT;
L=1;

# obsT[obsT$Month==1,3];
model1 <- data.frame();
model2 <- data.frame();

# mrmse <- function(o,m){sqrt(mean((o-m)^2));}

if(0){
	for(m in 1:12){
		mm <- sprintf("%02d",m);

		m1 <- read.table(paste(mdl1,mm,L,"txt",sep="."), skip=6);
		m1$Month <- m;	# add months
		m1$Season <- m2s(m);	#	add seasons
		m1 <- m1[,c(1,3,4,2)];	#	sort the fields
		names(m1) <- c('Year','Month','Season','M1');	#	add header names
		m1$M1 <- exp(m1$M1)-epsilon;	#
		model1 <- rbind(model1,m1);
		model1T <- model1[model1$Year <= endDT-vld,];		# model 1 - trn
		model1V <- model1[model1$Year >= startDT+trn,];			# model 1 - validation

		m2 <- read.table(paste(mdl2,mm,L,"txt",sep="."), skip=6);
		m2$Month <- m;	# add months
		m2$Season <- m2s(m);	#	add seasons
		m2 <- m2[,c(1,3,4,2)];	#	sort the fields
		names(m2) <- c('Year','Month','Season','M2');	#	add header names
		m2$M2 <- exp(m2$M2)-epsilon;	#
		model2 <- rbind(model2,m2);
		model2T <- model2[model2$Year <= endDT-vld,];		# model 2 - trn
		model2V <- model2[model2$Year >= startDT+trn,];			# model 2 - validation
	}
	# print(model1[model1$Season==1,]);

	print("Season")
	if(doCli){
		print("Year,Observed,ECHAM4p5,RMSE1,W1,wECHAM4p5,CFSv2,RMSE2,W2,wCFSv2,Climatology,RMSE3,W3,wClimatology,Combination,R2,MSSS");
	# }else{
	# 	print("Year,Observed,ECHAM4p5,W1,wECHAM4p5,CFSv2,W2,wCFSv2,Combination,R2,MSSS");
	}
	for(s in 1:4){
		if(doCli){
			oT <- obsT[obsT$Season==s,]$Observed;
			oV <- obsV[obsV$Season==s,]$Observed;

			clT=rep(clim[clim$Season==s,]$Climatology, each=trn*3);	#	3 months per season
			clV=rep(clim[clim$Season==s,]$Climatology, each=vld*3);	#	3 months per season

			m1T <- model1T[model1T$Season==s,];
			m1V <- model1V[model1V$Season==s,];

			m2T <- model2T[model2T$Season==s,];
			m2V <- model2V[model2V$Season==s,];
			print(s);
			# print(rmse(c(oT),c(m1T$M1))^-1)
			d <- (rmse(c(oT),c(m1T$M1))^-1 + rmse(c(oT),c(m2T$M2))^-1 + rmse(c(oT),c(clT))^-1)^-1;
			w1 <- d/rmse(c(oT),c(m1T$M1));
			w2 <- d/rmse(c(oT),c(m2T$M2));
			wcl <- d/rmse(c(oT),c(clT));
			comb <- m1V$M1*w1 + m2V$M2*w2 + clV*wcl;
			r2 <- cor(c(oV),c(comb),use="pairwise.complete.obs",method="spearman")^2;
			ms <- 1-(sum((oV-comb)^2)/sum((comb-clV)^2))^2
			print(paste(m1V$Year, oV, m1V$M1, rmse(c(oT),c(m1T$M1)), w1, m1V$M1*w1, m2V$M2, d/w2, w2, m2V$M2*w2, clV, d/wcl, wcl, clV*wcl, comb, r2, ms, sep=","));

		# }else{

		}
		# print(model1[model1$Season==s,]$M1);

		# print("obs");
		# print(paste("Observed", obs[obs$Season==s,]$Year, obs[obs$Season==s,]$Month, s, obs[obs$Season==s,]$Observed, sep=","));
		# cat("Observed", obs[obs$Season==s,]$Year, obs[obs$Season==s,]$Month, s, obs[obs$Season==s,]$Observed, "\n");
		# print(clim);
		# print(paste("Model 1", model1$Year[model1$Season==s],  sep=","));
		# print(c(model1$Year[model1$Season==s]));
		# print(model2);
		# print(paste("Model 2", model2$Year[model2$Season==s], model2$Month[model2$Season==s], s, model2$M2[model2$Season==s], sep=","));
	}

	if(0){

		clim <- data.frame();
		for(month in unique(obsT$Month))
			clim <- rbind(clim,c(month,mean(obsT[obsT$Month == month,3])));
		names(clim) <- c('Month','Avg');

		print("Season")
		if(doCli){
			print("Year,Observed,ECHAM4p5,W1,wECHAM4p5,CFSv2,W2,wCFSv2,Climatology,W3,wClimatology,Combination,R2,MSSS");
		}else{
			print("Year,Observed,ECHAM4p5,W1,wECHAM4p5,CFSv2,W2,wCFSv2,Combination,R2,MSSS");
		}

		for(s in 1:4){
			oT <- obsT[obsT$Season==s,]$Observed;
			oV <- obsV[obsV$Season==s,]$Observed;

			# print(model1T[model1T$Season==s,]);
			if(doCli){
				clT=rep(clim[s,2], each=trn*3);
				clV=rep(clim[s,2], each=vld*3);
				m1T <- model1T[model1T$Season==s,];
				m1V <- model1V[model1V$Season==s,];
				m2T <- model2T[model2T$Season==s,];
				m2V <- model2V[model2V$Season==s,];
				# print(length(clT));
				d <- (rmse(c(oT),c(m1T$M1))^-1 + rmse(c(oT),c(m2T$M2))^-1 + rmse(c(oT),c(clT))^-1)^-1;
				w1 <- d/rmse(c(oT),c(m1T$M1));
				w2 <- d/rmse(c(oT),c(m2T$M2));
				wcl <- d/rmse(c(oT),c(clT));
				# m1V$V2 <- m1V$V2*w1;
				# m2V$V2 <- m2V$V2*w2;
				print(s);
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
				# }else{
				# 	d <- (rmse(oT,m1)^-1 + rmse(oT,m2)^-1)^-1;
				# 	w1 <- d/rmse(oT,m1);
				# 	w2 <- d/rmse(oT,m2);
				# 	print(mm);
				# 	print(paste(m1V$Year, oV, m1V$M1, w1, m1V$M1*w1, m2V$M2, w2, m2V$M2*w2, m1V$V2*w1 + m2V$V2*w2,sep=","));
			}
		}
	}
}



if(1){
	print("Month")
	if(doCli){
		print("Year,Observed,ECHAM4p5,W1,wECHAM4p5,CFSv2,W2,wCFSv2,Climatology,W3,wClimatology,Combination,R2,MSSS");
	}else{
		print("Year,Observed,ECHAM4p5,W1,wECHAM4p5,CFSv2,W2,wCFSv2,Combination,R2,MSSS");
	}

	for(m in 1:12){
		oT=obsT[obsT$Month==m,3];
		oV=obsV[obsV$Month==m,3];
		# print(paste(oT,oV))
		mm <- sprintf("%02d",m);

		m1 <- paste(mdl1,mm,L,"txt",sep=".");
		m1 <- read.table(m1,skip=6);
		names(m1) <- c('Year','M1');
		m1$M1 <- exp(m1$M1)-epsilon;	#	V2 = value 2 = prediction
		m1T <- m1[m1$Year <= endDT-vld,];		# model 1 - trn
		# print(m1T);
		m1V <- m1[m1$Year >= startDT+trn,];			# model 1 - validation

		m2 <- paste(mdl2,mm,L,"txt",sep=".");
		m2 <- read.table(m2,skip=6);#, row.names=c("year,month,q"));
		names(m2) <- c('Year','M2');
		m2$M2 <- exp(m2$M2)-epsilon;
		m2T <- m2[m2$Year <= endDT-vld,];		# model 2 - trn
		m2V <- m2[m2$Year >= startDT+trn,];			# model 2 - validation

		# print(m1V$M1)
		# m1=m1T$M1;
		# m2=m2T$M2;
		# print(oT$Observed);
		# Validation

		if(doCli){
			clT=rep(clim[m,2], each=trn);
			clV=rep(clim[m,2], each=vld);
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
		# }else{
		# 	d <- (rmse(oT,m1)^-1 + rmse(oT,m2)^-1)^-1;
		# 	w1 <- d/rmse(oT,m1);
		# 	w2 <- d/rmse(oT,m2);
		# 	print(mm);
		# 	print(paste(m1V$Year, oV, m1V$M1, w1, m1V$M1*w1, m2V$M2, w2, m2V$M2*w2, m1V$V2*w1 + m2V$V2*w2,sep=","));
		}

	}
}
