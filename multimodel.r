
# setwd("M:/ME/PhD/paper_1/Sites/data/")
setwd("/home/melans/servers/z/home/phd/paper_1/Sites/data/")

mrmse <- function(o,m){sqrt(mean((o-m)^2));}


# weights <- data.frame()


l <- 1
m <- 02
s <- '08194500'
for(s in c('08080500','08085500','08151500','08194500')){
   # print(paste0(s,'.all'));}
  data=read.csv(paste0(s,'.all'), header = FALSE, sep=" ");

  colnames(data) <- c("Year","Month","Leadtime","Observed","Climatology","CFSv2","ECHAM4p5")
  for(l in 1:4){
    for(m in 01:12){
      # data$Observed[(data$Month==m) & (data$Leadtime==l)]
      o <- data$Observed[data$Month==m & data$Leadtime==l]
      m1 <- data$CFSv2[data$Month==m & data$Leadtime==l]
      m2 <- data$ECHAM4p5[data$Month==m & data$Leadtime==l]
      m3 <- data$Climatology[data$Month==m & data$Leadtime==l]
      
      r1 <- mrmse(o,m1)^-1
      r2 <- mrmse(o,m2)^-1
      r3 <- mrmse(o,m3)^-1
      r0 <- r1+r2+r3;
      
      w1 <- r1/r0
      w2 <- r2/r0
      w3 <- r3/r0
      
      comb <- m1*w1 + m2*w2 + m3*w3
      
      print(paste(data$Year[data$Month==m & data$Leadtime==l], data$Month[data$Month==m & data$Leadtime==l], data$Leadtime[data$Month==m & data$Leadtime==l], o, m1, m1*w1, m2, m2*w2, m3, m3*w3, comb))
    }
    
  }
}
# 
  # w1
  # w2
  # w3
  
  # weighted.mean
  
  # mrmse <- function(o,m){sqrt(mean((o-m)^2));}
  #
  
  
  
  
  
  # pdf(corr);
  par(mfrow=c(3,2),mar=c(2.5,2.5,1.5,1.5));
  plot.new();
  legend(x=0,y=.5,title="Spearman Rank Correlation",c(models_names,"95% Confedence Level"),pch=c(models_pch,NA),lty=c(models_lty,1),col=c(models_col,"gray44"));
  for(l in 0:Ls){
    # l=4
    plot(x=NULL,,xlim=c(1,12),ylim=c(0,1),type="n",xaxt="s",xlab="Month",ylab="",mgp=c(-1,1,0), yaxs = "i");
    title(paste(l," months ahead"),line=-1);
    # axis(side=1,label=ifelse(l>5,TRUE,FALSE),at=F$M);
    axis(side=1,label=TRUE,at=seq(1,12));
    axis(side=2, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);
    axis(side=4, at=seq(0,1,.2), tck=-0.02, tcl=.4, labels=FALSE);
    axis(side=4, at=seq(0,1,.1), tck=-0.01, tcl=.2, labels=FALSE);
    
    # ((paste0(model,"5+6")))
    # cfsv2$M
    for(m in seq_along(models)){
      print(models_lty[m])
      model <- get(models[m]);
      lines(model$M[model$L==l],model$CORR_CV[model$L==l], type="b",pch=models_pch[m],lty=models_lty[m],col=models_col[m]);
      abline(1.96/sqrt(model$N[model$L==l]-3),0,col="gray44");
    }
    # lines(echam4p5$M[echam4p5$L==l],echam4p5$CORR_CV[echam4p5$L==l], type="b",pch=4,lty=5,col="red");
    # abline(1.96/sqrt(echam4p5$N[echam4p5$L==l]-3),0,col="gray44");
    
    
    
    abline(0,0,col="gray77");
  };
  mtext(paste(" Site #",site," (",sitename,")",sep=""),side=3,line=-2,adj=0,outer=TRUE,cex=.8);
  # dev.off();
  # warnings()
  
  
  