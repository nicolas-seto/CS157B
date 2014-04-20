#!/bin/bash

PARSE_FILE="homeDataAppended.csv"
URL="http://www.zillow.com/ajax/homedetail/HomeValueChartData.htm?mt=1&zpid="
NEW_FILE="historicalZestimates.csv"

# Extract all the zpids in the first column
zpids=$(cut -d , -f 1 ${PARSE_FILE})

(( counter = 0 ))
for line in $(echo ${zpids}) ; do
    if [ $line == "zpid" ] ; then
        continue
    elif [ $counter -lt 0 ] ; then
        echo "Skipping line $counter"
        continue
    elif [ $counter -gt 1000 ] ; then
        echo "Reached a thousand files"
        break
    else
        echo "Extracting past zestimates for home $line . . ."
        homeValues=$(curl "${URL}${line}")
        homeValuesComma=$(echo "$homeValues" | sed "s/\t/,/g")
        (( count = 0 ))
        echo "Parsing home data for relevant data . . ."
        for line2 in $(echo "$homeValuesComma") ; do
            if [ count == 0 ] ; then
                continue
            elif [[ $line2 =~ "This home" ]] ; then
                echo "$line2" | sed "s/\([0-9]\+\)\/\([0-9]\+\)\/\([0-9]\+\)/\3-\1-\2/g" | sed "s/,This home//g" >> "$NEW_FILE"
            fi
            (( count++ ))
        done

        (( counter++ ))
    fi
done
echo "DONE"
