# options(warn=-1);
args <- commandArgs(TRUE);
# print (args);q()
cfsv2_data <- args[1];
echam4p5_data <- args[2];
Ls <- args[3];
# Ls <- Ls-1;
site <- args[4];
sitename <- gsub("_"," ",args[5]);

corr <- args[6];
msss <- args[7];

corr_ey <- args[8];
msss_ey <- args[9];

models <- c("cfsv2","echam4p5")
models_names <- c("CFSv2","ECHAM4p5")
models_col <- c("blue","red")
models_pch <- c(1,4)
models_lty <- c(3,5)

# n=29;

cfsv2=read.csv(cfsv2_data, row.names=NULL);
echam4p5=read.csv(echam4p5_data, row.names=NULL);

pdf(corr);
par(mfrow=c(3,2),mar=c(2.5,2.5,1.5,1.5));
plot.new();
# legend(x=0,y=.5,title="Spearman Rank Correlation",c("Cross Validation","95% Confedence Level"),pch=c(4,NA),lty=c(5,1),col=c(2,"gray44"));
# legend(x=0,y=.5,title="Spearman Rank Correlation",c("CFSv2","ECHAM4p5","95% Confedence Level"),pch=c(1,4,NA),lty=c(3,5,1),col=c("blue","red","gray44"));
legend(x=0,y=.5,title="Spearman Rank Correlation",c(models_names,"95% Confedence Level"),pch=c(models_pch,NA),lty=c(models_lty,1),col=c(models_col,"gray44"));
for(l in 0:Ls){
  plot(x=NULL,,xlim=c(1,12),ylim=c(0,1),type="n",xaxt="s",xlab="Month",ylab="",mgp=c(-1,1,0), yaxs = "i");
  title(paste(l," months ahead"),line=-1);
  # axis(side=1,label=ifelse(l>5,TRUE,FALSE),at=F$M);
  # axis(side=1,label=TRUE,at=cfsv2$M);
  axis(side=1,label=TRUE,at=seq(1,12));
  axis(side=2, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);
  axis(side=4, at=seq(0,1,.2), tck=-0.02, tcl=.4, labels=FALSE);
  axis(side=4, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);

  for(m in seq_along(models)){
    model <- get(models[m]);
    lines(model$M[model$L==l],model$CORR_CV[model$L==l], type="b",pch=models_pch[m],lty=models_lty[m],col=models_col[m]);
    abline(1.96/sqrt(model$N[model$L==l]-3),0,col="gray44");
  }

  abline(0,0,col="gray77");
};
mtext(paste(" Site #",site," (",sitename,")",sep=""),side=3,line=-2,adj=0,outer=TRUE,cex=.8);
dev.off();



pdf(msss);
par(mfrow=c(3,2),mar=c(2.5,2.5,1.5,1.5));
plot.new();
# legend(x=0,y=.5,title="Mean Square Skill Score",c("Cross Validation"),pch=c(4,16),lty=c(5,3),col=c(2,4));
legend(x=0,y=.5,title="Mean Square Skill Score",c(models_names),pch=c(models_pch),lty=c(models_lty),col=c(models_col));
# legend(x=0,y=.5,title="Mean Square Skill Score",c(models_names,"95% Confedence Level"),pch=c(models_pch),lty=c(models_lty),col=c(models_col));
for(l in 0:Ls){
  plot(x=NULL,,xlim=c(1,12),ylim=c(0,1),type="n",xaxt="s",xlab="Month",ylab="",mgp=c(-1,1,0), yaxs = "i");
  title(paste(l," months ahead"),line=-1);
  axis(side=1,label=TRUE,at=seq(1,12));
  axis(side=2, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);
  axis(side=4, at=seq(0,1,.2), tck=-0.02, tcl=.4, labels=FALSE);
  axis(side=4, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);

  for(m in seq_along(models)){
    model <- get(models[m]);
    lines(model$M[model$L==l],model$MSSS_CV[model$L==l], type="b",pch=models_pch[m],lty=models_lty[m],col=models_col[m]);
  }

  abline(0,0,col="gray77");
};
mtext(paste(" Site #",site," (",sitename,")",sep=""),side=3,line=-2,adj=0,outer=TRUE,cex=.8);
dev.off();



pdf(corr_ey);
par(mfrow=c(3,2),mar=c(2.5,2.5,1.5,1.5));
plot.new();
legend(x=0,y=.5,title="Spearman Rank Correlation (ENSO Yes)",c(models_names,"95% Confedence Level"),pch=c(models_pch,NA),lty=c(models_lty,1),col=c(models_col,"gray44"));
for(l in 0:Ls){
  plot(x=NULL,,xlim=c(1,12),ylim=c(0,1),type="n",xaxt="s",xlab="Month",ylab="",mgp=c(-1,1,0), yaxs = "i");
  title(paste(l," months ahead"),line=-1);
  axis(side=1,label=TRUE,at=seq(1,12));
  axis(side=2, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);
  axis(side=4, at=seq(0,1,.2), tck=-0.02, tcl=.4, labels=FALSE);
  axis(side=4, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);

  for(m in seq_along(models)){
    model <- get(models[m]);

    lines(model$M[model$L==l],model$CORR_CV_EY[model$L==l], type="b",pch=models_pch[m],lty=models_lty[m],col=models_col[m]);
    lines(model$M[model$L==l],1.96/sqrt(model$N1[model$L==l]-3) ,lty=1,col="gray77");
    polygon(
      c(0,0,model$M[model$L==l],13,13),
      c(0,1.96/sqrt(model$N1[model$L==l][1]-3),
      1.96/sqrt(model$N1[model$L==l]-3),
      1.96/sqrt(model$N1[model$L==l][12]-3),
      0),
      col = "#08040411");

  }
  abline(0,0,col="gray77");
};
mtext(paste(" Site #",site," (",sitename,")",sep=""),side=3,line=-2,adj=0,outer=TRUE,cex=.8);
dev.off();



pdf(msss_ey);
par(mfrow=c(3,2),mar=c(2.5,2.5,1.5,1.5));
plot.new();
# legend(x=0,y=.5,title="Mean Square Skill Score (ENSO Yes)",c("Cross Validation"),pch=c(4,16),lty=c(5,3),col=c(2,4));
legend(x=0,y=.5,title="Mean Square Skill Score (ENSO Yes)",c(models_names),pch=c(models_pch),lty=c(models_lty),col=c(models_col));
for(l in 0:Ls){
  plot(x=NULL,,xlim=c(1,12),ylim=c(0,1),type="n",xaxt="s",xlab="Month",ylab="",mgp=c(-1,1,0), yaxs = "i");
  title(paste(l," months ahead"),line=-1);
  axis(side=1,label=TRUE,at=seq(1,12));
  axis(side=2, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);
  axis(side=4, at=seq(0,1,.2), tck=-0.02, tcl=.4, labels=FALSE);
  axis(side=4, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);

  for(m in seq_along(models)){
    model <- get(models[m]);
    lines(model$M[model$L==l],model$MSSS_CV_EY[model$L==l], type="b",pch=models_pch[m],lty=models_lty[m],col=models_col[m]);
  }

  abline(0,0,col="gray77");
};
mtext(paste(" Site #",site," (",sitename,")",sep=""),side=3,line=-2,adj=0,outer=TRUE,cex=.8);
dev.off();
