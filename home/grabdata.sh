#!/bin/bash

FILE=uniqueZpids.txt

if [ ! -d "zestimates" ]; then
	mkdir zestimates
fi

lineNum=0

while read line ; do
URL="http://www.zillow.com/webservice/GetZestimate.htm?zws-id=X1-ZWz1ds8scamvwr_axb7v&zpid=${line}"
curl -o "${line}_zestimate.xml" "$URL"
mv "${line}_zestimate.xml" zestimates/
(( lineNum++ ))
if [ $lineNum -eq 1000 ] ; then
	break
fi
done < $FILE
