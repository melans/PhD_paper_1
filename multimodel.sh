
#68.6624.190612.133101 Elansary@hpcc2 ~/phd/paper_1 $
#for f in {cfsv2,echam4p5}/Sites/*/0_temp/flow.1;do awk '$1>=1982&&$1<=2016' $f > Sites/data/$(sed 's/\/Sites\//_/g; s/\/.*$//g' <<<$f).data;done
#74.6630.190612.133451 Elansary@hpcc2 ~/phd/paper_1 $
for f in {cfsv2,echam4p5}/Sites/*/0_temp/flow.1;do awk '$1>=1982&&$1<=2016' $f > Sites/data/$(sed 's/^.*\/Sites\///g; s/\/.*$//g' <<<$f).obs;done


#for l in 1 2 3 4;do f={cfsv2,echam4p5}/Sites/*/3_forecast/CV/CV.$l.txt;echo $f Sites/data/$(sed 's/\/Sites\//_/g; s/\/.*$//g' <<<$f).data;done


#for f in {cfsv2,echam4p5}/Sites/*/3_forecast/CV/CV.*;do awk 'NR>6{split(FILENAME,f,"/");split(f[6],x,".");print $1,x[2],exp($2) >f[1]"_"f[3]"_"x[3]}' $f;done
epsilon=.0001;

