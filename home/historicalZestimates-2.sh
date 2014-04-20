#!/bin/bash

PARSE_FILE="homeDataAppended.csv"
URL="http://www.zillow.com/ajax/homedetail/HomeValueChartData.htm?mt=1&zpid="
NEW_FILE="historicalZestimates.csv"
APPEND="14"
LT=13001
GT=14000

# Extract all the zpids in the first column
zpids=$(cut -d , -f 1 ${PARSE_FILE})

(( counter = 0 ))
for line in $(echo ${zpids}) ; do
    if [ $line == "zpid" ] ; then
        continue
    elif [ $counter -lt $LT ] ; then
        echo "Skipping line $counter"
        (( counter++ ))
        continue
    elif [ $counter -gt $GT ] ; then
        echo "Reached $counter files"
        break
    else
        echo "Extracting past zestimates for home $line . . ."
        curl -o "${line}.txt" "${URL}${line}"
        (( count = 0 ))
        echo "Parsing home data for relevant data . . ."
        while read line2 ; do
            if [ count == 0 ] ; then
                continue
            elif [[ $line2 =~ "This home" ]] ; then
                echo "$line2" | sed "s/\t/,/g" | sed "s/\([0-9]\+\)\/\([0-9]\+\)\/\([0-9]\+\)/\3-\1-\2/g" | sed "s/,This home//g" >> "${NEW_FILE}${APPEND}"
            fi
            (( count++ ))
        done < "${line}.txt"
        
        rm -f "${line}.txt"
        (( counter++ ))
    fi
done
echo "DONE"
