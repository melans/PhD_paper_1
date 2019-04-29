#!/bin/sh
echo "+===================================================================+";
echo "|     Welcome to Streamflow Prediction Statistical Model (SPSM)     |";
echo "|                       by: anssary@gmail.com                       |";
echo "+===================================================================+";
################################################################################
# unset count;unset sites;unset parameter;unset parameters;unset startDT;unset endDT;unset Sites;unset Ls;unset Ms;
. fun.lib;
init;
# DBG=(1 4);
################################################################################
# enso;
for site in "${!sites[@]}"; do
  initsite;
  # download;
  # fix_outliers;
  # verify;
  # if [[ $verified == 1 ]]; then
		# MSG "Site $sitename is valid, $exist_ vs $supposed_ , proceeding ...";
    # format;
    # forecasts
    # calculate
    # rpss;
    graph;
  # else
  #   MSG "Site $sitename has missing values, skipping , $exist_ vs $supposed_";
  # fi;
  # sitepdfs=$site"_"$sitepdfs;
  # corrpdfs="$corrpdfs $stp5/$site""_""CORR.pdf ";
  # mssspdfs="$mssspdfs $stp5/$site""_""MSSS.pdf "
  # pdfunite $stp5/* $path/$site.pdf;
done
# pdfs=`find $Sites/*/*.pdf -type f -printf "%f"|sed 's/.pdf/_/g'`
# pdfunite $Sites/*/*.pdf $Sites/$pdfs"merged.pdf";
# pdfunite $corrpdfs $mssspdfs $Sites/$sitepdfs"merged.pdf"
# pdfunite "$Sites/*/5*/*.pdf" $Sites/merged.pdf
echo;echo "DONE";
# return 0;
