#!/bin/sh

#echo $0.r;exit 0;

. fun.lib;
site="08151500";
doClim="1";  # consider climatology 1/0
init;
m1;

# m="01";L=1;

# observed
#obs="`awk '$1>='$startDT'&&$1<='$startDT+$training-1'&&$2=='"$m"'{printf $3","}' $stp0/flow.1|sed 's/,$//g';`";
obs=$stp0/flow.1;
#climatology
#clim=`Rscript -e 'cat(mean(c('$obs')))'`;
#clim=$stp0/flow.1;
# model 1
#mdl1="`awk '$1>='$startDT'&&$1<='$startDT+$training-1'{printf exp($2)-'$epsilon'","}' $stp3/CV/CV.$m.$L.txt|sed 's/,$//g';`";
mdl1=$stp3/CV/CV;
# .$m.$L.txt;
m2;
# model 2
#mdl2="`awk '$1>='$startDT'&&$1<='$startDT+$training-1'{printf exp($2)-'$epsilon'","}' $stp3/CV/CV.$m.$L.txt|sed 's/,$//g';`";
mdl2=$stp3/CV/CV;
# .$m.$L.txt;

#Rscript -e 'if(!require(hydroGOF)){install.packages("hydroGOF")};cat(",",rmse(c('$mdl1'),c('$obs')));cat(",",rmse(c('$mdl2'),c('$obs')),",")';

R < r.r --no-save --quiet --slave --args \
  "$startDT" \
  "$endDT" \
  "$obs" \
  "$mdl1" \
  "$mdl2" \
  "$epsilon" \
  "$doClim"  | sed 's/\(\[.*\]\|"\)//g'|awk -F, '{print (NF>1)$0}'|sed 's/^1/,/'|sed 's/^0//'|sed 's/,/\t/g' > rslts.csv
  # "$doClim"  | sed 's/\(\[.*\]\|"\)//g'|tr -d ' '|awk -F, '{print (NF>1)$0}'|sed 's/^1/,/'|sed 's/^0//'|sed 's/,/\t/g' > rslts.csv

  # |awk -F, '{print NF>1?" ":""$0}'
  # >/dev/null 2>/dev/null;




# climatology
# for m in `seq -w 01 12`; do
#   awk '$1>=$startDT&&$1<=$endDT&&$2=="'$m'"{x+=$3;i++}END{print "'$m'",x/i}' $stp0/flow.1;
# done



# DOTNET_CLI_TELEMETRY_OPTOUT

# install.packages('hydroGOF');
# library('hydroGOF');
# actual <- c(1.1, 1.9, 3.0, 4.4, 5.0, 5.6);
# predicted <- c(0.9, 1.8, 2.5, 4.5, 5.0, 6.2);
# rmse(actual, predicted);
