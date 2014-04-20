#!/bin/bash

PARSE_FILE="homeDataAppended.csv"
URL="http://www.zillow.com/ajax/homedetail/HomeValueChartData.htm?mt=1&zpid="
NEW_FILE="historicalZestimates.csv"

# Extract all the zpids in the first column
zpids=$(cut -d , -f 1 ${PARSE_FILE})

old_IFS=$IFS
IFS=$'\n'
for line in $(echo ${zpids}) ; do
    if [ $line -eq "zpid" ] ; then
        continue
    else
        echo "Extracting past zestimates for home $line . . .\n"
        homeOutput=$(curl "${URL}${line}")
        homeOutputComma=$(echo "${homeOutput}" | sed "s/\t/,/g")
        (( count = 0 ))
        echo "date,value,series,zpid\n" > "$NEW_FILE"
        echo "Parsing home data for relevant data . . .\n"
        for line2 in $(echo ${homeOutputComma}) ; do
            if [ count == 0 ] ; then
                continue
            elif [[ $line2 =~ "This home" ]] ; then
                echo "$line2" | sed "s/(\d+)\/(\d+)\/(\d+)/\3-\1-\2/g" | sed "s/This home/$line\n/g" > "$NEW_FILE"
            fi
            (( count++ ))
        done
    fi
done
IFS=$old_IFS
echo "DONE\n"