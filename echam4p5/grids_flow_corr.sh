yr1=1982
yrs=9
snippets="Sites/08151500/snippets"
parameters="PRATE TMP"
mkdir $snippets
echo -e "Parameter\tGrid\tCorrelation" > $snippets/grids_flow_correlations.txt
for yrs in {1..29}; do
  awk -vORS=, '$1>='$yr1'&&$1<='$[yr1+yrs-1]'{print $3}' $snippets/../0_temp/flow.1|sed 's/,$//' > $snippets/flow.grids
  flow=`awk 'NR<2,1' $snippets/flow.grids`;
  echo >> $snippets/grids_flow_correlations.txt;
  echo "From $yr1 to $[yr1+yrs-1]  => $yrs years" >> $snippets/grids_flow_correlations.txt
  for p in $parameters; do
    cat $snippets/../0_temp/$p.??.1.1|awk '$1>='$yr1'&&$1<='$[yr1+yrs-1]''|awk '{g[$2"_"$3]=g[$2"_"$3]$4","}END{for(i in g)print i,g[i]}'|sed 's/,$//' > $snippets/$p.grids
    while read x; do
      g=($x);
      echo -en "$p\t${g[0]}\t">> $snippets/grids_flow_correlations.txt;
      # Rscript -e 'cor=cor(c('$flow'),c('${g[1]}'),use="pairwise.complete.obs",method="spearman");cat(",",ifelse(cor>0,cor,0),sep="")' >> $snippets/grids_flow_correlations.txt;
      Rscript -e 'cor=cor(c('$flow'),c('${g[1]}'),use="pairwise.complete.obs",method="spearman");cat("",cor,sep="")' >> $snippets/grids_flow_correlations.txt;
      echo >> $snippets/grids_flow_correlations.txt;
    done < $snippets/$p.grids;
  done;
done;
