#!/bin/bash

MAIN="historicalZestimates.csv"
(( i = 1 ))
for (( i ; i < 18 ; i++ )) ; do
    cat "${MAIN}${i}" >> "$MAIN"
done
