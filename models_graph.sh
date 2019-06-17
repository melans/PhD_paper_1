unset count;unset site;unset sites;unset parameter;unset parameters;unset startDT;unset endDT;unset Sites;unset Ls;unset Ms;
declare -A parameter sites;

sites["08194500"]="29/27,-100/-98"; # Nueces Rv nr Tilden
sites["08080500"]="34/32,-103/-99"; # DMF Brazos Rv nr Aspermont
sites["08151500"]="31.5/29.5,-100.5/-98";  # Llano Rv at Llano
sites["08085500"]="34/32,-100/-98"; # Clear Fk Brazos Rv at Ft Griffin

startDT="1982";
endDT="2016";
Sites="Sites";  #  data folder
Ls=4;    # lead times
Ms=12;  # months

epsilon=.0001

graphs="$Sites/graphs"
# cpt_CV="$PWD/$stp3/CV";



################################################################################
function graph {
  corr=$graphs/$site"_"1_CORR.pdf;
  msss=$graphs/$site"_"2_MSSS.pdf;
  corr_ey=$graphs/$site"_"3_CORR_EY.pdf;
  msss_ey=$graphs/$site"_"4_MSSS_EY.pdf;
  corr_en=$graphs/$site"_"5_CORR_EN.pdf;
  msss_en=$graphs/$site"_"6_MSSS_EN.pdf;
  # rpss=$graphs/$site"_"5_RPSS.pdf;

  # echo $rslt2;
  # R < script.r "$(realpath $rslt2)" "$(realpath $corr)" $Ls $site `echo "$sitename"|sed 's/\s/_/g'` --save;
  # echo "$(realpath $rslt2)" "$(realpath $corr)" "$(realpath $msss)" $Ls $site ${sitename// /_};

  sitename=`awk -F\\\t 'END{print $3}' cfsv2/$Sites/$site/1_download/latlon.info`;


  # echo "$(realpath cfsv2/$Sites/$site/4_calculate/results.2.csv)" \
  #   "$(realpath echam4p5/$Sites/$site/4_calculate/results.2.csv)" \
  #   $Ls $site "${sitename// /_}" \
  #   "$(realpath $corr)" \
  #   "$(realpath $msss)" \
  #   "$(realpath $corr_ey)" \
  #   "$(realpath $msss_ey)" \

# echo   "$(realpath $corr)" \
#   "$(realpath $msss)" \
#   "$(realpath $corr_ey)" \
#   "$(realpath $msss_ey)" \
#   "$(realpath $corr_en)" \
#   "$(realpath $msss_en)"
  R < models_graph.r --no-save --quiet --slave --args \
  "$Sites/data/cfsv2.$site.results.2.csv" \
  "$Sites/data/echam4p5.$site.results.2.csv" \
  "$Sites/data/multimodel.$site.results.2.csv" \
  $Ls $site "${sitename// /_}" \
  "$(realpath $corr)" \
  "$(realpath $msss)" \
  "$(realpath $corr_ey)" \
  "$(realpath $msss_ey)" \
  "$(realpath $corr_en)" \
  "$(realpath $msss_en)" \
  >/dev/null 2>/dev/null;

  #
  # # RPSS Calculations and Graphs
  for L in `seq 1 $Ls`; do
    rpss="pdf('$graphs/$site"_7_"RPSS_$L.pdf'); ";
    # CFSv2
    rpss="$rpss boxplot(";
    # for model in "cfsv2" "echam4p5";do
    for m in `seq -w 01 $Ms`; do
      r=$(awk 'NR>1{printf $4","}' cfsv2/Sites/$site/3_forecast/$m.$L.rpss|sed 's/,$//g');
      rpss="$rpss c($r), ";
    done;
    rpss="$rpss xaxt='n',yaxt='n',col='#0000ff08',border=c('blue') ,boxwex=0.2,at= 1:12-.15,ylim=c(-3,1));"

    # ECHAM4.5
    rpss="$rpss boxplot(";
    # for model in "cfsv2" "echam4p5";do
    for m in `seq -w 01 $Ms`; do
      r=$(awk 'NR>1{printf $4","}' echam4p5/Sites/$site/3_forecast/$m.$L.rpss|sed 's/,$//g');
      rpss="$rpss c($r), ";
    done;
    # rpss="$rpss main='Site #"$site" "${sitename// /_}"\nRPSS - $ModelName ($L month lead time)',xlab='Month',ylab='RPSS', las=2, names=c('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'));abline(0,0,col=2,lty=2,lwd=1);";
    rpss="$rpss main='Site #"$site" ("$sitename")\nRPSS - ($L month lead time)',xlab='Month',ylab='RPSS',las=2,col='#ff000008',border=c('red'), names=c('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'), boxwex=0.2,at= 1:12+.15,ylim=c(-3,1),add=TRUE); abline(0,0,col=1,lty=2,lwd=1); legend('bottomleft', inset=.02,c('CFSv2','ECHAM4.5'), fill=c('blue','red'), horiz=TRUE, cex=0.8);"

    # rpss="$rpss  main='Site #"$site" ("$sitename")\nRPSS - ($L month lead time)',xlab='Month',ylab='RPSS', las=2, names=c('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'));abline(0,0,col=2,lty=2,lwd=1);";



    # xaxt="n",
    # col="#0000ff08",
    # border=c("blue") ,
    # boxwex=0.2,
    # at= 1:12-.15,
    # ylim=c(-3,1)


    # done;

    # echo;echo $rpss;echo;

    Rscript -e "$rpss; dev.off();" >/dev/null 2>/dev/null;

#   done;
done;




  # echo $graphs/$site"_"$ModelName"_"*.pdf $Sites/$site.$ModelName.pdf;
  pdfunite $graphs/$site"_"*.pdf $Sites/$site.pdf;

  MSG "Final graph file://$PWD/$Sites/$site.pdf";echo;

}
##############################################################################


################################################################################
function MSG {
  # MSGs
  counter;
  # set +x
  text="$1";delay="$2";if [ -z $delay ]; then delay=".01"; fi
  echo -en "\n";
  for i in $(seq 0 $(expr length "${text}")); do printf "${text:$i:1}";sleep ${delay};done;
}
################################################################################

################################################################################
function MSGx {
  counter;
  echo -en "$1";
}
################################################################################


################################################################################
function counter {
  count=$[$count+1];
  echo -en "\r\t\t\t\t\t\t\t\t\t\t\t..... $count";
  # if [[ $count -eq ${DBG[0]} ]]; then
  #   set -x;
  # elif [[ $count -eq ${DBG[1]} ]]; then
  #   set +x;
  # fi
  # if [[ $counter -lt $DBG ]]; then
  #   set -x;
  # else
  #   set +x;
  # fi
}
################################################################################


################################################################################
function multi {
  # multi Obs M1 M2 M3
  Rscript -e 'mrmse <- function(o,m){sqrt(mean((o-m)^2));};o <- c('$1'); m1 <- c('$2'); m2 <- c('$3'); m3 <- c('$4'); r1 <- mrmse(o,m1)^-1; r2 <- mrmse(o,m2)^-1; r3 <- mrmse(o,m3)^-1; r0 <- r1+r2+r3; w1 <- r1/r0; w2 <- r2/r0; w3 <- r3/r0; cat(m1*w1 + m2*w2 + m3*w3,sep=",");'
}
################################################################################


# models_names <- c("CFSv2","ECHAM4p5")
# for ModelName in "CFSv2" "ECHAM4p5";do
for site in "${!sites[@]}";do
  MSG "Graphing ... $site";echo;

  cp "cfsv2/$Sites/$site/4_calculate/results.1.csv" "$Sites/data/cfsv2.$site.results.1.csv";
  cp "cfsv2/$Sites/$site/4_calculate/results.2.csv" "$Sites/data/cfsv2.$site.results.2.csv";

  cp "echam4p5/$Sites/$site/4_calculate/results.1.csv" "$Sites/data/echam4p5.$site.results.1.csv";
  cp "echam4p5/$Sites/$site/4_calculate/results.2.csv" "$Sites/data/echam4p5.$site.results.2.csv";

  # rslt1x="$Sites/data/multimodel.$site.results.1x.csv";
  rslt1="$Sites/data/multimodel.$site.results.1.csv";
  pr -mts $Sites/data/{cfsv2,echam4p5}.$site.results.1.csv|awk 'function p(x){return x<0?x+.0001:x}{print $1,$2,$3,$4,p($5),p((NF<12)?$NF:$6)}' > $rslt1;

  rslt2="$Sites/data/multimodel.$site.results.2.csv";

  echo "M,L,CORR_CV,MSSS_CV,CORR_CV_EY,MSSS_CV_EY,CORR_CV_EN,MSSS_CV_EN,N,N1,N0" > $rslt2;
  # echo "M,L,CORR_CV,CORR_CV_EY,N,N1" > $rslt2;
  echo >> $rslt2;
  for m in `seq -w 01 $Ms`; do
#     # echo "m = $m">>$tst;
#     # counter;
#     # MSG " ";
#     ## corrected 9-23-17, between start_date and start+training
#     # clim=$(awk '$1<'$startDT'&&$1>='$[2*startDT-endDT-1]'&&$2=="'$m'"{y++;m+=$3}END{print m/y}' $stp0/flow.1);
#     # clim=$(awk '$1>='$startDT'&&$1<=2011&&$2=="'$m'"{y++;m+=$3}END{print m/y}' $stp0/flow.1);
    q=$(awk -vORS=, '$2=="'$m'"&&!$3{print $5}' $rslt1|sed 's/,$//');
    clim=$(Rscript -e 'cat(mean(c('$q')))');
    # clim=$(awk '$1>='$startDT'&&$1<='$endDT'&&$2=="'$m'"&&!$3{y++;m+=$5}END{print m/y}' $rslt1);
#
#     # q1=$(awk -vORS=, '$2=="'$m'"&&$3==0&&$4{print $5}' $rslt1|sed 's/,$//');
#     # q0=$(awk -vORS=, '$2=="'$m'"&&$3==0&&!$4{print $5}' $rslt1|sed 's/,$//');
#
    for L in `seq 0 $Ls`; do
      counter;
      MSGx "\r       ==>  ${M[10#$m]}  ==>  $L months lead time ";
      #       # if [[ $L == 0 ]]; then L="x"; else L=$L;fi
      #       # L=$L
      echo -n $m","$L
      echo -n $m","$L >> $rslt2;

#       # q1=$(awk -vORS=, 'NR==FNR&&$2=="'$m'"&&$3=="'$L'"{enso[$1]++}NR>FNR&&enso[$1]&&$2=="'$m'"&&$3==0&&$4{print $5}' $rslt1 $rslt1|sed 's/,$//');

      m_CV1=$(awk -vORS=, '$2=="'$m'"&&$3=="'$L'"{print $5}' $rslt1|sed 's/,$//');
      m_CV2=$(awk -vORS=, '$2=="'$m'"&&$3=="'$L'"{print $6}' $rslt1|sed 's/,$//');

      mm=$(multi $q $m_CV1 $m_CV2 $clim);

      q1=$(awk -vORS=, '$2=="'$m'"&&!$3&&$4{print $5}' $rslt1|sed 's/,$//');
      clim1=$(Rscript -e 'cat(mean(c('$q1')))');
      m1_CV1=$(awk -vORS=, '$2=="'$m'"&&$3=="'$L'"&&$4{print $5}' $rslt1|sed 's/,$//');
      m1_CV2=$(awk -vORS=, '$2=="'$m'"&&$3=="'$L'"&&$4{print $6}' $rslt1|sed 's/,$//');

      mm1=$(multi $q1 $m1_CV1 $m1_CV2 $clim1);
      # echo $mm1

      q0=$(awk -vORS=, '$2=="'$m'"&&!$3&&!$4{print $5}' $rslt1|sed 's/,$//');
      clim0=$(Rscript -e 'cat(mean(c('$q0')))');
      m0_CV1=$(awk -vORS=, '$2=="'$m'"&&$3=="'$L'"&&!$4{print $5}' $rslt1|sed 's/,$//');
      m0_CV2=$(awk -vORS=, '$2=="'$m'"&&$3=="'$L'"&&!$4{print $6}' $rslt1|sed 's/,$//');

      mm0=$(multi $q0 $m0_CV1 $m0_CV2 $clim0);


#      # r1_CV=$(awk -vORS=, '$2=="'$m'"&&$3=="'$L'"&&$4{print $3?$5:$6}' $rslt1|sed 's/,$//');
#       # r1_CV=$(awk -vORS=, 'NR==FNR&&$2=="'$m'"&&$3==0&&$4{enso[$1]++}NR>FNR&&enso[$1]&&$2=="'$m'"&&$3=="'$L'"{print $3?$5:$6}' $rslt1 $rslt1|sed 's/,$//');



#
#         # if [[ $L == 0 ]]; then
#         #   r_RP=$r_CV;
#         #   r1_RP=$r1_CV;
#         # else
#         #   r_RP=$(awk -vORS=, '$2=="'$m'"&&$3=="'$L'"{print $6}' $rslt1|sed 's/,$//');
#         #   r1_RP=$(awk -vORS=, '$2=="'$m'"&&$3=="'$L'"&&$4{print $6}' $rslt1|sed 's/,$//');
#         # fi
#
#         # r0_CV=$(awk -vORS=, '$2=="'$m'"&&$3=="'$L'"&&!$4{print $5}' $rslt1|sed 's/,$//');
#         # r0_RP=$(awk -vORS=, '$2=="'$m'"&&$3=="'$L'"&&!$4{print $6}' $rslt1|sed 's/,$//');
# # echo;echo "m=$m | L=$L | clim=$clim | q=$q | q1=$q1 | r_cv=$r_CV | r1_CV=$r1_CV";echo;
        Rscript -e 'cor=cor(c('$q'),c('$mm'),use="pairwise.complete.obs",method="spearman");cat(",",ifelse(cor>0,cor,0),sep="")'>>$rslt2;
        # echo $q $mm;echo;exit;
        Rscript -e 'clim='$clim';q=c('$q');r=c('$mm');msss=1-(sum((q-r)^2)/sum((q-clim)^2));cat(",",ifelse(msss>0,msss,0),sep="")'>>$rslt2;
        Rscript -e 'cor=cor(c('$q1'),c('$mm1'),use="pairwise.complete.obs",method="spearman");cat(",",ifelse(cor>0,cor,0),sep="")'>>$rslt2;
        Rscript -e 'clim='$clim';q=c('$q1');r=c('$mm1');msss=1-(sum((q-r)^2)/sum((q-clim)^2));cat(",",ifelse(msss>0,msss,0),sep="")'>>$rslt2;
        Rscript -e 'cor=cor(c('$q0'),c('$mm0'),use="pairwise.complete.obs",method="spearman");cat(",",ifelse(cor>0,cor,0),sep="")'>>$rslt2;
        Rscript -e 'clim='$clim';q=c('$q0');r=c('$mm0');msss=1-(sum((q-r)^2)/sum((q-clim)^2));cat(",",ifelse(msss>0,msss,0),sep="")'>>$rslt2;
#
#         # Rscript -e 'cor=cor(c('$q'),c('$r_RP'),use="pairwise.complete.obs",method="spearman");cat(",",ifelse(cor>0,cor,0),sep="")'>>$rslt2;
#         # Rscript -e 'clim='$clim';q=c('$q');r=c('$r_RP');msss=1-(sum((q-r)^2)/sum((q-clim)^2));cat(",",ifelse(msss>0,msss,0),sep="")'>>$rslt2;
#         # Rscript -e 'cor=cor(c('$q1'),c('$r1_RP'),use="pairwise.complete.obs",method="spearman");cat(",",ifelse(cor>0,cor,0),sep="")'>>$rslt2;
#         # Rscript -e 'clim='$clim';q=c('$q1');r=c('$r1_RP');msss=1-(sum((q-r)^2)/sum((q-clim)^2));cat(",",ifelse(msss>0,msss,0),sep="")'>>$rslt2;
#         # Rscript -e 'cor=cor(c('$q0'),c('$r0_RP'),use="pairwise.complete.obs",method="spearman");cat(",",ifelse(cor>0,cor,0),sep="")'>>$rslt2;
#         # Rscript -e 'clim='$clim';q=c('$q0');r=c('$r0_RP');msss=1-(sum((q-r)^2)/sum((q-clim)^2));cat(",",ifelse(msss>0,msss,0),sep="")'>>$rslt2;
#
        _n=$(awk '$2=="'$m'"&&$3=="'$L'"{_++}END{print _}' $rslt1|sed 's/,$//');
        _n1=$(awk '$2=="'$m'"&&$3=="'$L'"&&$4{_++}END{print _}' $rslt1|sed 's/,$//');
        _n0=$(awk '$2=="'$m'"&&$3=="'$L'"&&!$4{_++}END{print _}' $rslt1|sed 's/,$//');
#
#         # echo ",$_n,$_n1">>$rslt2;
      echo ",$_n,$_n1,$_n0">>$rslt2;
    done;
    echo >> $rslt2;
  done;



  # path="$Sites/$site";
  # stp0="$path/0_temp";
  # stp1="$path/1_download";
  # stp2="$path/2_format";
  # stp3="$path/3_forecast";
  # stp4="$path/4_calculate";
  # graphs="$path/5_graphs";
  # mkdir -p $stp{0..5} >/dev/null 2>/dev/null;
  graph;
# done;
done
