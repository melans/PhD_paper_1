for f in {cfsv2,echam4p5}/Sites/*/0_temp/flow.1;do awk '$1>=1982&&$1<=2016' $f > Sites/data/$(sed 's/^.*\/Sites\///g; s/\/.*$//g' <<<$f).obs;done
epsilon=.0001;
rm Sites/data/*.data;
for f in {cfsv2,echam4p5}/Sites/*/3_forecast/CV/CV.*;do awk 'NR>6{split(FILENAME,f,"/");split(f[6],x,".");print $1,x[2],exp($2)-'"$epsilon"' >>"Sites/data/"f[1]"."f[3]"."x[3]".data"}' $f;done

for x in 08080500 08085500 08151500 08194500;do
  for l in 1 2 3 4;do
    awk 'FNR==1{++f}f==1{obs[$1" "$2]=$3;clim[$2]+=$3;xclim[$2]++}f==2{m1[$1" "$2]=$3}f==3{print $1,$2,'"$l"',obs[$1" "$2],clim[$2]/xclim[$2],m1[$1" "$2],$3}' \
    Sites/data/$x.obs Sites/data/cfsv2.$x.$l.data Sites/data/echam4p5.$x.$l.data > Sites/data/$x.$l.data;
  done;
  cat Sites/data/$x.?.data > Sites/data/$x.all;
done;
ll Sites/data/*.all



#for l in 1 2 3 4;do f={cfsv2,echam4p5}/Sites/*/3_forecast/CV/CV.$l.txt;echo $f Sites/data/$(sed 's/\/Sites\//_/g; s/\/.*$//g' <<<$f).data;done
#68.6624.190612.133101 Elansary@hpcc2 ~/phd/paper_1 $
#for f in {cfsv2,echam4p5}/Sites/*/0_temp/flow.1;do awk '$1>=1982&&$1<=2016' $f > Sites/data/$(sed 's/\/Sites\//_/g; s/\/.*$//g' <<<$f).data;done
#74.6630.190612.133451 Elansary@hpcc2 ~/phd/paper_1 $
#for f in {cfsv2,echam4p5}/Sites/*/3_forecast/CV/CV.*;do awk 'NR>6{split(FILENAME,f,"/");split(f[6],x,".");print $1,x[2],exp($2) >f[1]"_"f[3]"_"x[3]}' $f;done
