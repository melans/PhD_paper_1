# options(warn=-1);
args <- commandArgs(TRUE);
# print (args);q()
rslts <- args[1];
Ls <- args[2];
# Ls <- Ls-1;
site <- args[3];
sitename <- gsub("_"," ",args[4]);

corr <- args[5];
msss <- args[6];

corr_ey <- args[7];
msss_ey <- args[8];

corr_en <- args[9];
msss_en <- args[10];

# n=29;

F=read.csv(rslts, row.names=NULL);
pdf(corr);
par(mfrow=c(3,2),mar=c(2.5,2.5,1.5,1.5));
plot.new();
legend(x=0,y=.5,title="Spearman Rank Correlation",c("Cross Validation","95% Confedence Level"),pch=c(4,NA),lty=c(5,1),col=c(2,"gray44"));
for(l in 0:Ls){
  plot(x=NULL,,xlim=c(1,12),ylim=c(0,1),type="n",xaxt="s",xlab="Month",ylab="",mgp=c(-1,1,0), yaxs = "i");
  title(paste(l," months ahead"),line=-1);
  # axis(side=1,label=ifelse(l>5,TRUE,FALSE),at=F$M);
  axis(side=1,label=TRUE,at=F$M);
  axis(side=2, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);
  axis(side=4, at=seq(0,1,.2), tck=-0.02, tcl=.4, labels=FALSE);
  axis(side=4, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);

  lines(F$M[F$L==l],F$CORR_CV[F$L==l], type="b",pch=4,lty=5,col=2);
  abline(1.96/sqrt(F$N[F$L==l]-3),0,col="gray44");

  abline(0,0,col="gray77");
};
mtext(paste(" Site #",site," (",sitename,")",sep=""),side=3,line=-2,adj=0,outer=TRUE,cex=.8);
dev.off();



pdf(msss);
par(mfrow=c(3,2),mar=c(2.5,2.5,1.5,1.5));
plot.new();
legend(x=0,y=.5,title="Mean Square Skill Score",c("Cross Validation"),pch=c(4,16),lty=c(5,3),col=c(2,4));
for(l in 0:Ls){
  plot(x=NULL,,xlim=c(1,12),ylim=c(0,1),type="n",xaxt="s",xlab="Month",ylab="",mgp=c(-1,1,0), yaxs = "i");
  title(paste(l," months ahead"),line=-1);
  axis(side=1,label=TRUE,at=F$M);
  axis(side=2, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);
  axis(side=4, at=seq(0,1,.2), tck=-0.02, tcl=.4, labels=FALSE);
  axis(side=4, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);

  lines(F$M[F$L==l],F$MSSS_CV[F$L==l], type="b",pch=4,lty=5,col=2);

  abline(0,0,col="gray77");
};
mtext(paste(" Site #",site," (",sitename,")",sep=""),side=3,line=-2,adj=0,outer=TRUE,cex=.8);
dev.off();


pdf(corr_ey);
par(mfrow=c(3,2),mar=c(2.5,2.5,1.5,1.5));
plot.new();
legend(x=0,y=.5,title="Spearman Rank Correlation (ENSO Yes)",c("Cross Validation","95% Confedence Level"),pch=c(4,NA),lty=c(5,1),col=c(2,"gray44"));
for(l in 0:Ls){
  plot(x=NULL,,xlim=c(1,12),ylim=c(0,1),type="n",xaxt="s",xlab="Month",ylab="",mgp=c(-1,1,0), yaxs = "i");
  title(paste(l," months ahead"),line=-1);
  axis(side=1,label=TRUE,at=F$M);
  axis(side=2, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);
  axis(side=4, at=seq(0,1,.2), tck=-0.02, tcl=.4, labels=FALSE);
  axis(side=4, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);

  lines(F$M[F$L==l],F$CORR_CV_EY[F$L==l], type="b",pch=4,lty=5,col=2);
  lines(F$M[F$L==l],1.96/sqrt(F$N1[F$L==l]-3) ,lty=1,col="gray77");
  polygon(
    c(0,0,F$M[F$L==l],13,13),
    c(0,1.96/sqrt(F$N1[F$L==l][1]-3),
            1.96/sqrt(F$N1[F$L==l]-3),
            1.96/sqrt(F$N1[F$L==l][12]-3),
            0),
          col = "#08040411");

  abline(0,0,col="gray77");
};
mtext(paste(" Site #",site," (",sitename,")",sep=""),side=3,line=-2,adj=0,outer=TRUE,cex=.8);
dev.off();



pdf(msss_ey);
par(mfrow=c(3,2),mar=c(2.5,2.5,1.5,1.5));
plot.new();
legend(x=0,y=.5,title="Mean Square Skill Score (ENSO Yes)",c("Cross Validation"),pch=c(4,16),lty=c(5,3),col=c(2,4));
for(l in 0:Ls){
  plot(x=NULL,,xlim=c(1,12),ylim=c(0,1),type="n",xaxt="s",xlab="Month",ylab="",mgp=c(-1,1,0), yaxs = "i");
  title(paste(l," months ahead"),line=-1);
  axis(side=1,label=TRUE,at=F$M);
  axis(side=2, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);
  axis(side=4, at=seq(0,1,.2), tck=-0.02, tcl=.4, labels=FALSE);
  axis(side=4, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);

  lines(F$M[F$L==l],F$MSSS_CV_EY[F$L==l], type="b",pch=4,lty=5,col=2);

  abline(0,0,col="gray77");
};
mtext(paste(" Site #",site," (",sitename,")",sep=""),side=3,line=-2,adj=0,outer=TRUE,cex=.8);
dev.off();

pdf(corr_en);
par(mfrow=c(3,2),mar=c(2.5,2.5,1.5,1.5));
plot.new();
legend(x=0,y=.5,title="Spearman Rank Correlation (ENSO No)",c("Cross Validation","95% Confedence Level"),pch=c(4,NA),lty=c(5,1),col=c(2,"gray44"));
for(l in 0:Ls){
  plot(x=NULL,,xlim=c(1,12),ylim=c(0,1),type="n",xaxt="s",xlab="Month",ylab="",mgp=c(-1,1,0), yaxs = "i");
  title(paste(l," months ahead"),line=-1);
  axis(side=1,label=TRUE,at=F$M);
  axis(side=2, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);
  axis(side=4, at=seq(0,1,.2), tck=-0.02, tcl=.4, labels=FALSE);
  axis(side=4, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);

  lines(F$M[F$L==l],F$CORR_CV_EN[F$L==l], type="b",pch=4,lty=5,col=2);
  lines(F$M[F$L==l],1.96/sqrt(F$N0[F$L==l]-3) ,lty=1,col="gray77");
  polygon(
    c(0,0,F$M[F$L==l],13,13),
    c(0,1.96/sqrt(F$N0[F$L==l][1]-3),
            1.96/sqrt(F$N0[F$L==l]-3),
            1.96/sqrt(F$N0[F$L==l][12]-3),
            0),
          col = "#08040411");

  abline(0,0,col="gray77");
};
mtext(paste(" Site #",site," (",sitename,")",sep=""),side=3,line=-2,adj=0,outer=TRUE,cex=.8);
dev.off();



pdf(msss_en);
par(mfrow=c(3,2),mar=c(2.5,2.5,1.5,1.5));
plot.new();
legend(x=0,y=.5,title="Mean Square Skill Score (ENSO No)",c("Cross Validation"),pch=c(4,16),lty=c(5,3),col=c(2,4));
for(l in 0:Ls){
  plot(x=NULL,,xlim=c(1,12),ylim=c(0,1),type="n",xaxt="s",xlab="Month",ylab="",mgp=c(-1,1,0), yaxs = "i");
  title(paste(l," months ahead"),line=-1);
  axis(side=1,label=TRUE,at=F$M);
  axis(side=2, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);
  axis(side=4, at=seq(0,1,.2), tck=-0.02, tcl=.4, labels=FALSE);
  axis(side=4, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);

  lines(F$M[F$L==l],F$MSSS_CV_EN[F$L==l], type="b",pch=4,lty=5,col=2);

  abline(0,0,col="gray77");
};
mtext(paste(" Site #",site," (",sitename,")",sep=""),side=3,line=-2,adj=0,outer=TRUE,cex=.8);
dev.off();
