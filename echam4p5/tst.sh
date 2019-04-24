startDT="1983";
endDT="2009";
# training="29";  # Length of initial training period (suggested value 29):
training="$[((endDT-startDT)+1)/2]";  # Length of initial training period (suggested value 29):
Sites="Sites";  #  data folder
Ls=4;    # lead times
Ms=12;  # months

small=.0001;

site="08151500";
path="$Sites/$site";
stp0="$path/0_temp";
stp1="$path/1_download";
stp2="$path/2_format";
stp3="$path/3_forecast";
stp4="$path/4_calculate";
stp5="$path/5_graphs";

rslts="$stp4/results";
rslt0=$rslts.0.csv;
rslt1=$rslts.1.csv;
rslt2=$rslts.2.csv;

cpt_CV="$PWD/$stp3/CV";

m="01";L=1

awk '$2=='$m'&&$3==0{print $5}' $rslt1|wc -l;
awk '$2=='$m'&&$3=='$L'{print $3?$5:$6}' $rslt1|wc -l;
awk '$2=='$m'&&$3==0&&$4{print $5}' $rslt1|wc -l;
awk '$2=='$m'&&$3=='$L'&&$4{print $3?$5:$6}' $rslt1|wc -l;

q=$(awk -vORS=, '$2=='$m'&&$3==0{print $5}' $rslt1|sed '$ s/,$//');
r_CV=$(awk -vORS=, '$2=='$m'&&$3=='$L'{print $3?$5:$6}' $rslt1|sed '$ s/,$//');
q1=$(awk -vORS=, '$2=='$m'&&$3==0&&$4{print $5}' $rslt1|sed '$ s/,$//');
r1_CV=$(awk -vORS=, '$2=='$m'&&$3=='$L'&&$4{print $3?$5:$6}' $rslt1|sed '$ s/,$//');

echo $q $r_CV $q1 $r1_CV;

Rscript -e 'cor=cor(c('$q'),c('$r_CV'),use="pairwise.complete.obs",method="spearman");cat(",",ifelse(cor>0,cor,0),sep="")';
Rscript -e 'clim='$clim';q=c('$q');r=c('$r_CV');msss=1-(sum((q-r)^2)/sum((q-clim)^2));cat(",",ifelse(msss>0,msss,0),sep="")';
Rscript -e 'cor=cor(c('$q1'),c('$r1_CV'),use="pairwise.complete.obs",method="spearman");cat(",",ifelse(cor>0,cor,0),sep="")';
Rscript -e 'clim='$clim';q=c('$q1');r=c('$r1_CV');msss=1-(sum((q-r)^2)/sum((q-clim)^2));cat(",",ifelse(msss>0,msss,0),sep="")';
