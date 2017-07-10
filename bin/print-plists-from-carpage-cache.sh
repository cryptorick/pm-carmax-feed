#!/bin/sh

cat stock-numbers |
    while read sn; do
        cat carpage-cache/$sn |
            bin/carpage-to-caranalytics.awk |
            bin/caranalytics-to-plist.awk
    done
