library(zoo);library(ggplot2);library(dplyr)

Sites <- 'm:/ME/PhD/paper_1/Sites/';
p <- 'm:/ME/PhD/paper_1/Sites/data/';
dpdf <- 'm:/ME/PhD/paper_1/Sites/Droughts_';
fpdf <- 'm:/ME/PhD/paper_1/Sites/Floods_';

setwd(p);
getwd();



sites <- c("08080500","08085500","08151500","08194500");

models <- c("Obs","Clim","CFSv2","ECHAM4p5","Floods","Droughts");
models_names <- c("Obs","Clim","CFSv2","ECHAM4p5  ","Floods","Droughts");
models_col <- c("red","grey40","blue","#009999","navy","maroon");
models_pch <- c(NA,NA,NA,NA,NA,NA);
models_lty <- c(1,5,2,5,1,1);
names <- c('Year','Month','Lead','Obs','Clim','CFSv2','ECHAM4p5');


# 
# files = list.files(path=p,pattern = "*.all");
# datalist = lapply(files, 
#                   function(x){
#                     d <- read.csv(paste0(p,x), header = F, sep=" ");
#                     q <- quantile(d$V3, c(.1,.9));
#                     print(paste0('Droughts for site (',x,') :'));
#                     print(d[d$V3 <= q[1],]);
#                     print(paste0('Floods for site (',x,') :'));
#                     print(d[d$V3 >= q[2],]);
#                     }
#                   )
# 
# # month.abb[c(1:12)]

qs <- c(.05, .95); # quantiles
fth=3; # flood consecutive months threshold
dth=3; # drought consecutive months threshold


# s=2
for(s in seq_along(sites)){

  d <- read.csv(paste0(p,sites[s],'.all'),header = F, sep=" ");
  names(d) <- names;
  d$MM <- 0;
  
  # Multimodel
  for(m in 1:12){
    for(l in 1:4){
      # print(l)
      m1l1 <- d[d$Month==m & d$Lead==l,];
      
      M1 <- m1l1$Clim;
      M2 <- m1l1$CFSv2;
      M3 <- m1l1$ECHAM4p5;
      
      R1 <- 1/sqrt(mean((m1l1$Obs-m1l1$Clim)^2));
      R2 <- 1/sqrt(mean((m1l1$Obs-m1l1$CFSv2)^2));
      R3 <- 1/sqrt(mean((m1l1$Obs-m1l1$ECHAM4p5)^2));
      R <- 1/(R1+R2+R3);
      
      d$MM[d$Month==m & d$Lead==l] <- (M1*R1+M2*R2+M3*R3)*R;
    }
  }
  
  
  d <- d[d$Lead==1,];
  d <- d[order(d[,1],d[,2]),];
  q <- quantile(d$Obs, qs);
  q
  d$Date <- as.yearmon(paste(d$Year, d$Month), "%Y %m");
  d$D_F <- ifelse(d$Obs >= q[2],1,ifelse(d$Obs <= q[1],-1,0));
  
  # Floods 
  df <- d[d$D_F>0,]
  df <- df[order(df[,4],decreasing = T),][1:5,]
  df <- df[order(df[,1],df[,2]),]
  # df
  # dim(df)[1]
  
  
  # Droughts
  dd <- d[d$D_F<0,]
  dd <- data.frame(dd,id=seq.int(nrow(dd)),m=diff(c(dd$Month,NA)),y=diff(c(dd$Year,NA)))
  dd$m[dd$m==-11 & dd$y==1] <- 1
  dd1 <- which(dd$m==1 & (lag(dd$m)!=1 | is.na(lag(dd$m))))
  dd2 <- which((dd$m!=1 | is.na(dd$m)) & lag(dd$m)==1)
  dds <- array(c(dd1, dd2, dd2-dd1+1),dim = c(length(dd1),3,1))
  dds <- dds[dds[,3,]>=dth,1:2,]
  dds <- paste0("dd[c(",dds[,1],":",dds[,2],"),];")
  dd <- lapply(dds,function(x){eval(parse(text=x))})
  print(paste0("Droughts - Site : ",sites[s]));
  print(dd)
  # length(dd)
  
  # plot(df$Obs)
  
  # Plotting
  # pdf(paste0(dfpdf,sites[s],".pdf"));
  # # layout(matrix(c(1:5), ncol=4, byrow=TRUE), heights=c(3,3,3,3,2))
  # # par(oma=c(0,2,.5,.5),mar=c(.5,.5,.5,.5));
  # plot(x=NULL,font.main = 1,
  #      xlim=c(1,12),ylim=c(0,1),type="n",
  #      xlab="",ylab="",mgp=c(0,1,0), xaxs = "i", yaxs = "i",
  #      xaxt = "n"
  #      # ifelse(s<4, "n", "s")
  #      ,yaxt = "n"
  #      # ifelse(l>1, "n", "s")
  # );
  
  
  
  
  # d$DF_Observed <- ifelse(d$Obs >= q[2],1,ifelse(d$Obs <= q[1],-1,0));
  # d$DF_CFSv2 <- ifelse(d$CFSv2 >= q[2],1,ifelse(d$CFSv2 <= q[1],-1,0));
  # d$DF_ECHAM4p5 <- ifelse(d$ECHAM4p5 >= q[2],1,ifelse(d$ECHAM4p5 <= q[1],-1,0));
  
  # d[d$DF_Observed>0 & d$DF_CFSv2>0 & d$DF_ECHAM4p5>0,]
  # d[d$DF_Observed<0 & d$DF_CFSv2<0 & d$DF_ECHAM4p5<0,]
  
  # write.csv(d,paste0("m:/ME/PhD/paper_1/writing/F_D_data_",sites[s],".csv"))
  # d[d$Obs >= q[2],]
  
  
  # # df[,1]
  
  # Floods 
  # df <- d[d$D_F>0,]
  # df <- data.frame(df,id=seq.int(nrow(df)),m=diff(c(df$Month,NA)),y=diff(c(df$Year,NA)))
  # df$m[df$m==-11 & df$y==1] <- 1
  # df1 <- which(df$m==1 & (lag(df$m)!=1 | is.na(lag(df$m))))
  # df2 <- which((df$m!=1 | is.na(df$m)) & lag(df$m)==1)
  # dfs <- array(c(df1, df2, df2-df1+1),dim = c(length(df1),3,1))
  # dfs <- dfs[dfs[,3,]>=fth,1:2,]
  # dfs <- paste0("df[c(",dfs[,1],":",dfs[,2],"),];")
  # df <- lapply(dfs,function(x){eval(parse(text=x))})
  
  # library(plyr)
  # ldply(list(df), function(x) x$toDataFrame())
  # 
  # 
  # summary(df)
  # capture.output(list(df),file=paste0("m:/ME/PhD/paper_1/writing/F_D_data_",sites[s],"_F.csv"))
  # list(df)
  # lapply(df,
  #        function(x){
  #          write.table(data.frame(x),paste0("m:/ME/PhD/paper_1/writing/F_D_data_",sites[s],"_F.csv"), sep = " ",append = T)
  #        }
  #        )
  # write.csv(df,paste0("m:/ME/PhD/paper_1/writing/F_D_data_",sites[s],"_F.csv"))
  
  # d[d$D_F<0 & d$Obs>0,]
  # d[d$Obs<=q[1],]
  
  
  
  # length(dd)
  # write.csv(dd,paste0("m:/ME/PhD/paper_1/writing/F_D_data_",sites[s],"_D.csv"))
  # 
  
  
  
  # # pdf("m:/ME/PhD/paper_1/writing/floods_droughts.pdf", paper="USr", width = 4000, height = 1000, pointsize = 4)
  # jpeg(paste0("m:/ME/PhD/paper_1/writing/",sites[s],"-floods_droughts.jpg"), width = 1200, height = 600, quality = 1000, res = 200, pointsize = 5)
  # layout(matrix(c(1:2), ncol=1, byrow = T),heights = c(5,1.2))
  # par(mar=c(0,2.1,4.3,.1));
  # m=1;tcl=-.8;cex=.8
  # plot(d$Date,d$Obs,xlab="",ylab="",main="", type="l", xaxs = "i", yaxs = "i",cex.axis=1.3 , pch=models_pch[m],lty=models_lty[m],col=models_col[m]);
  # for(m in 2:4) lines(d$Date,d[[models[m]]],lty=models_lty[m],col=models_col[m]);
  # abline(v = 1982:2016, col = "grey60", lty = 3);
  # axis(side=3, at=d$Date[d$D_F>0], tcl=tcl, col = models_col[5], col.axis=models_col[5], las=3, cex.axis=cex, labels = as.yearmon(d$Date[d$D_F>0],"%Y %m") );
  # axis(side=3, at=d$Date[d$D_F<0], tcl=tcl, col = models_col[6], col.axis=models_col[6], las=3, cex.axis=cex, labels = as.yearmon(d$Date[d$D_F<0],"%Y %m") );
  # box();plot.new();
  # par(mar=c(3,0,0,0));
  # legend(x="center",y=1,title=paste0(letters[s],") Observed and Forecast Streamflow, and Floods/Droughts Episodes for (",sites[s],")"),c(models_names), cex = 1.2, pch=c(models_pch),lty=c(models_lty),col=c(models_col),ncol=6, );
  # dev.off();

}

