
for f in {cfsv2,echam4p5}/Sites/*/0_temp/flow.1;do cp $f Sites/data/$(sed 's/\/Sites\//_/g; s/\/.*$//g' <<<$f).data;done
