# unset count site sites parameter parameters startDT endDT Sites Ls Ms;
unset count;unset site;unset sites;unset parameter;unset parameters;unset startDT;unset endDT;unset Sites;unset Ls;unset Ms;
declare -A parameter sites;





################################################################################
# Functions Library
################################################################################

################################################################################
echo "Initializing ... ";

################################################################################
function init {
  # site=$1;
  parameter["prec"]="total precipitation";
  parameter["st"]="surface temperature";

  XYURI="http://waterservices.usgs.gov/nwis/site/?format=rdb&sites=";
  mapURI="http://water.usgs.gov/wsc/cat/";
  # flowURI="https://waterservices.usgs.gov/nwis/stat/?format=rdb&statReportType=monthly&statTypeCd=mean&missingData=on&parameterCd=00060&startDT=$[startDT-1]-12&endDT=$[endDT+1]-0$[Ls-1]&sites=";
  flowURI="https://waterservices.usgs.gov/nwis/stat/?format=rdb&statReportType=monthly&statTypeCd=mean&missingData=on&parameterCd=00060&sites=";
  gridsURI="http://iridl.ldeo.columbia.edu/SOURCES/.IRI/.FD/.ECHAM4p5/.Forecast/.ca_sst/.ensemble24/.MONTHLY/[M]average";
  # gridsURI="http://iridl.ldeo.columbia.edu/SOURCES/.IRI/.FD/.ECHAM4p5/.Forecast/.ca_sst/.ensemble24/.MONTHLY/[M]average/S/(0000%201%20Jan%20$startDT)/(0000%201%20Dec%20$endDT)/RANGEEDGES";

  # gridsURI="http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP/.EMC/.CFSv2/.MONTHLY/.FLXF/.surface"
# "http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP/.EMC/.CFSv2/.MONTHLY/.FLXF/.surface/.PRATE/Y/31.1/29.8/RANGEEDGES/X/-99.9/-98.3/RANGEEDGES/L/1/VALUES/ngridtable+table-+skipanyNaN+5+-table+.html"
# "http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP/.EMC/.CFSv2/.MONTHLY/.FLXF/.surface/.PRATE/Y/31.1/29.8/RANGEEDGES/X/-99.9/-98.3/RANGEEDGES/L/1/VALUES/ngridtable/5+ncoltable.html?tabopt.N=6&tabopt.1=text&tabopt.2=text&tabopt.3=text&tabopt.4=text&tabopt.5=text&tabopt.6=markNaN&NaNmarker=-9999&tabtype=R.tsv&eol=LF+%28unix%29&filename=datafile.tsv"
# "http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP/.EMC/.CFSv2/.MONTHLY/.FLXF/.surface/.PRATE/Y/31.1/29.8/RANGEEDGES/X/-99.9/-98.3/RANGEEDGES/L/1/VALUES/ngridtable/5+ncoltable.html?tabopt.N=6&tabopt.1=text&tabopt.2=text&tabopt.3=text&tabopt.4=text&tabopt.5=text&tabopt.6=markNaN&NaNmarker=-9999&tabtype=free&eol=LF+%28unix%29&filename=datafile.txt"
# "http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP/.EMC/.CFSv2/.MONTHLY/.FLXF/.surface/.PRATE/Y/31.1/29.8/RANGEEDGES/X/-99.9/-98.3/RANGEEDGES/L/1/VALUES/ngridtable/5+ncoltable.html?tabopt.N=6&tabopt.1=text&tabopt.2=text&tabopt.3=text&tabopt.4=text&tabopt.5=text&tabopt.6=markNaN&NaNmarker=-9999&tabtype=tsv&eol=LF+%28unix%29&filename=datafile.tsv"
# "http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP/.EMC/.CFSv2/.MONTHLY/.FLXF/.surface/.PRATE/Y/31.1/29.8/RANGEEDGES/X/-99.9/-98.3/RANGEEDGES/L/1/VALUES/ngridtable/5+ncoltable.html?tabopt.N=6&tabopt.1=text&tabopt.2=text&tabopt.3=text&tabopt.4=text&tabopt.5=text&tabopt.6=markNaN&NaNmarker=-9999&tabtype=csv&eol=LF+%28unix%29&filename=datafile.csv"
# "http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP/.EMC/.CFSv2/.MONTHLY/.FLXF/.surface/.PRATE/Y/31.1/29.8/RANGEEDGES/X/-99.9/-98.3/RANGEEDGES/L/1/VALUES/ngridtable/5+ncoltable.html?tabopt.N=6&tabopt.1=text&tabopt.2=text&tabopt.3=text&tabopt.4=text&tabopt.5=text&tabopt.6=markNaN&NaNmarker=-9999&tabtype=html&eol=LF+%28unix%29&filename=datafile.html"
# "http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP/.EMC/.CFSv2/.MONTHLY/.FLXF/.surface/.PRATE/Y/31.1/29.8/RANGEEDGES/X/-99.9/-98.3/RANGEEDGES/L/1/VALUES/ngridtable+table-+skipanyNaN+5+-table+.html"
# "http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP/.EMC/.CFSv2/.MONTHLY/.FLXF/.surface/.PRATE/Y/31.1/29.8/RANGEEDGES/X/-99.9/-98.3/RANGEEDGES/L/1/VALUES/[M+S+]average/ngridtable+table-+skipanyNaN+3+-table+.html"

  # endDt = 22 Dec 2010
  # gridsURI2="[M]average/S/(0000%201%20Jan%20$startDT)/(0000%2022%20Dec%20$endDT)/RANGEEDGES"

  M=(Months Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
  # First year from which to forecast
  FYF=$[$startDT+$training];
  # echo $FYF;exit
	mkdir -p $Sites >/dev/null 2>/dev/null;
  # folders / steps
}
################################################################################

################################################################################
function initsite {
  path="$Sites/$site";
  stp0="$path/0_temp";
  stp1="$path/1_download";
  stp2="$path/2_format";
  stp3="$path/3_forecast";
  stp4="$path/4_calculate";
  stp5="$path/5_graphs";
	mkdir -p $stp{0..5} >/dev/null 2>/dev/null;
  _dnld_ "$XYURI$site" "$stp1/latlon.info";
  sitename=`awk -F\\\t 'END{print $3}' $stp1/latlon.info`;
  sitemap=`awk -F\\\t 'END{print $NF}' $stp1/latlon.info`;

  echo;echo -n "==========> Preparing site #$site ($sitename)";

  rslts="$stp4/results";
  rslt0=$rslts.0.csv;
  rslt1=$rslts.1.csv;
  rslt2=$rslts.2.csv;

  cpt_CV="$PWD/$stp3/CV";
}
################################################################################

