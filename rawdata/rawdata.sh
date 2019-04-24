small=.0001;

awk '$1>1983&&$1<2011' ../echam4p5/Sites/08151500/0_temp/flow.1>obs;

echo -n "">m1;
for m in {1..12};do awk 'NR>6{print $1,'$m',exp($2)-'$small'}' ../cfsv2/Sites/08151500/3_forecast/CV/CV.$m.1.txt>>m1;done;
sort -nk1,2 m1>m1x;
mv m1x m1;

echo -n "">m2;
for m in {1..12};do awk 'NR>6{print $1,'$m',exp($2)-'$small'}' ../cfsv2/Sites/08151500/3_forecast/CV/CV.$m.1.txt>>m2;done;
sort -nk1,2 m2>m2x;
mv m2x m2;

pr -mts obs m1 m2|awk -vOFS="," 'NR<2{print "Year","Month","Season","Obs","M1","M2"}{print $1,$2,(int($2/3)%4)+1,$3,$6,$9}'>all



# R < r.r --no-save --quiet --slave --args \
#   "$startDT" \
#   "$endDT" \
#   "$obs" \
#   "$mdl1" \
#   "$mdl2" \
#   "$epsilon" \
#   "$doCli"  | sed 's/\(\[.*\]\|"\)//g'|awk -F, '{print (NF>1)$0}'|sed 's/^1/,/'|sed 's/^0//'|sed 's/,/\t/g' > rslts.csv
