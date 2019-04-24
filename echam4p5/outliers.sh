#!/bin/bash

## generic error/usage function
function usage {
    local ecode=${2:-0}
    test -n "$1" && printf "\n %s\n" "$1" >&2
cat >&2 << helpMessage

usage:  ${0//*\//} datafile

This script will process a 2-column datafile to provide average,
mean and std. deviation for each time group of data while removing
outlying data from the calculation. The datafile format:

    time    value
    0.01667 20.53  <- outlier
    0.01667 6.35
    0.01667 6.94
    ...

Options:

    -h  |  --help  program help (this file)

helpMessage

    exit $ecode;
}

## function to calculate average of arguments
function average {

    local sum=0
    declare -i count=0
    for n in $@; do
        sum=$( printf "scale=6; %s+%s\n" "$sum" "$n" | bc )
        ((count++))
    done
    avg=$( printf "scale=6; %s/%s\n" "$sum" "$count" | bc )
    printf "%s\n" "$avg"
}

## function to examine arguments a remove any outlier
#  that is greater than 4 from the average.
#  values without the outlier are returned to command line
function rmoutlier {

    local avg=$(average $@)
    local diff=0
    for i in $@; do
        diff=$( printf "scale=6; %s-%s\n" "$i" "$avg" | bc )
        [ "${diff:0:1}" = '-' ]  && diff="${diff:1}"            # quick absolute value hack
        [ "${diff:0:1}" = '.' ]  && diff=0                      # set any fractional 0
        if [ $((${diff//.*/})) -lt 4 ]; then
            clean+=( $i )                                       # if whole num diff < 4, keep
        else
            echo "->outlier: $i" >&2                            # print outlier to stderr
        fi
    done
    echo ${clean[@]}                                            # return array
}

## respond to -h or --help
test "${1:1}" = 'h' || test "${1:2}" = 'help' && usage

## set variables
dfn="${1:-dat/outlier.dat}"     # datafile (default dat/outlier.dat)
ofn="${2:-dat/outlier.out}"     # output file (default dat/outlier.out)
declare -a tmp                  # temporary array holding data for given time
ptime=0                         # variable holding previous time (flag for 1st line)

:> "$ofn"                       # truncate output file

## validate input filename
test -r "$dfn" || usage "Error: invalid input. File '$dfn' not found" 1

while read -r time data || [ -n "$data" ]; do               # read all lines of data

    if [ "$ptime" = 0 ] || [ "$ptime" = "$time" ]; then     # if no change in time
        tmp+=( $data )                                      # fill array with data
    else
        echo "  time: $ptime  data : '${tmp[@]}'" >&2       # output array to stderr
        printf "  time: %s  " "$ptime" >>"$ofn"             # output array to file

        ## process data
        clean=( $(rmoutlier ${tmp[@]} ) )                   # remove outlier
        echo  "time: $ptime  clean: '${clean[@]}'" >&2      # output clean array
        avgclean=$( average ${clean[@]} )                   # average clean array
        printf "  avgclean: %s\n\n" "$avgclean" >&2         # output avg of clean array
        printf "  avgclean: %s\n" "$avgclean" >>"$ofn"      # output avg of clean array to file

        unset tmp           # reset variables for next time
        unset clean
        unset avgclean

        tmp+=( $data )      # read first value for next time set
    fi

    ptime="$time"           # save previous time for comparison

done <"$dfn"

## process final time block

echo "  time: $ptime  data : '${tmp[@]}'" >&2

## process data
clean=( $(rmoutlier ${tmp[@]} ) )
echo  "  time: $ptime  clean: '${clean[@]}'" >&2
avgclean=$( average ${clean[@]} )
printf "  avgclean: %s\n\n" "$avgclean" >&2

unset tmp
unset clean
unset avgclean

exit 0
