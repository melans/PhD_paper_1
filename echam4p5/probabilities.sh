echo -e "Site\tMonth\tLead\tBelow\tNormal\tAbove">probabilities;
for f in Sites/*/3*/CV/extra/*Probabilities*;
do awk 'NR==1{split(FILENAME,s,"/");split(s[6],m,".");printf "%s\t%s\t%s\t",s[2],m[2],m[3]}NR==7||NR==12||NR==17{printf "%s\t",$2}END{printf "\n"}' $f>>probabilities;
done

