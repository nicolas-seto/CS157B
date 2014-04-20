#!/bin/bash

PARSE_FILE="homeDataAppended.csv"
URL="http://www.zillow.com/ajax/homedetail/HomeValueChartData.htm?mt=1&zpid="
NEW_FILE="historicalZestimates.csv"

# Extract all the zpids in the first column
zpids=$(cut -d , -f 1 ${PARSE_FILE})
echo "date,value,series,zpid" > "$NEW_FILE"

for line in $(echo ${zpids}) ; do
    if [ $line == "zpid" ] ; then
        continue
    else
        echo "Extracting past zestimates for home $line . . ."
        curl -o "${line}.txt" "${URL}${line}"
        (( count = 0 ))
        echo "Parsing home data for relevant data . . ."
        while read line2 ; do
            if [ count == 0 ] ; then
                continue
            elif [[ $line2 =~ "This home" ]] ; then
                echo "$line2" | sed "s/\t/,/g" | sed "s/\([0-9]\+\)\/\([0-9]\+\)\/\([0-9]\+\)/\3-\1-\2/g" | sed "s/This home/${line}\\n/g" >> "$NEW_FILE"
            fi
            (( count++ ))
        done < "${line}.txt"
        
        rm -f "${line}.txt"
    fi
done
echo "DONE\n"