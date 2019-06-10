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
  # rpss=$graphs/$site"_"5_RPSS.pdf;
  # corr_en=$graphs/$site"_"5_CORR_EN.pdf;
  # msss_en=$graphs/$site"_"6_MSSS_EN.pdf;

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

  R < models_graph.r --no-save --quiet --slave --args \
  "$(realpath cfsv2/$Sites/$site/4_calculate/results.2.csv)" \
  "$(realpath echam4p5/$Sites/$site/4_calculate/results.2.csv)" \
  $Ls $site "${sitename// /_}" \
  "$(realpath $corr)" \
  "$(realpath $msss)" \
  "$(realpath $corr_ey)" \
  "$(realpath $msss_ey)" \
  >/dev/null 2>/dev/null;

  #
  # # RPSS Calculations and Graphs
  for L in `seq 1 $Ls`; do
    rpss="pdf(\"$graphs/$site.RPSS.$L.pdf\"); boxplot(";
    for m in `seq -w 01 $Ms`; do
      for model in "cfsv2" "echam4p5";do
        stp3=$model/Sites/$site/3_forecast
        o=$(awk 'NF>1{print (exp($2)-'$epsilon')<1?0:(exp($2)-'$epsilon')}' $stp3/CV/Y.$m)|tr ' ' ,;
        # p1="`Rscript -e 'quantile(c('$o'),c(.33))'|tail -1`";
        # p2="`Rscript -e 'quantile(c('$o'),c(.67))'|tail -1`";
        # pr -mts \
        # <(awk -vp1="$p1" -vp2="$p2" 'NF>1{o=(exp($2)-'$epsilon')<1?0:(exp($2)-'$epsilon');print $1,o<=p1?"1 1":o<=p2?"0 1":"0 0"}' $cpt_CV/Y.$m) \
        # <(awk '{P[$1]=$2/100" "P[$1]+$2/100}END{for(y='$startDT';y<='$endDT';y++)print P[y]}' $cpt_CV/extra/CV.$m.$L.Forecast_Probabilities.txt) |\
        # awk 'BEGIN{print "Year RPS_f RPS_clm RPSS"}{f=($2-$4)^2+($3-$5)^2;c=($2-.33)^2+($3-.67)^2;print $1,f,c,1-f/c}'>$graphs/$m.$L.rpss;

        r=$(awk 'NR>1{print $4}' $stp3/$m.$L.rpss);
        r=$(echo $r|tr ' ' ,);
        rpss="$rpss c($r),";
      done;
    done;

    rpss="$rpss  main='Site #"$site" "${sitename// /_}"\nRPSS - $ModelName ($L month lead time)',xlab='Month',ylab='RPSS', las=2, names=c('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'));abline(0,0,col=2,lty=2,lwd=1);";
    echo;echo $rpss;echo;
    Rscript -e "$rpss;dev.off();" >/dev/null 2>/dev/null;

  done;




  # echo $graphs/$site"_"$ModelName"_"*.pdf $Sites/$site.$ModelName.pdf;
  pdfunite $graphs/$site"_"*.pdf $Sites/$site.pdf;

  MSG "Final graph file://$PWD/$Sites/$site.pdf";echo;

}
################################################################################


################################################################################
function MSG {
  # MSGs
  # counter;
  # set +x
  text="$1";delay="$2";if [ -z $delay ]; then delay=".01"; fi
  echo -en "\n";
  for i in $(seq 0 $(expr length "${text}")); do printf "${text:$i:1}";sleep ${delay};done;
}
################################################################################




# models_names <- c("CFSv2","ECHAM4p5")
# for ModelName in "CFSv2" "ECHAM4p5";do
for site in "${!sites[@]}";do
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
