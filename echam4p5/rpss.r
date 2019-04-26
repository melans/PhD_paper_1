# options(warn=-1);
args <- commandArgs(TRUE);
# print (args);q()
pdf <- args[1];
L <- args[2];
site <- args[3];
sitename <- gsub("_"," ",args[4]);

rpss <- args[5];

print (rpss)

pdf(pdf);

boxplot(
  rpss,
  xlab='Month',ylab='RPSS', las=2,
  names=c('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')
)
# main=paste0('Site #',site,' ',sitename,', RPSS'),
dev.off();
