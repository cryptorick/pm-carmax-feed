#!/bin/sh

itm="$1"

# Vehicle info is in JSON.
awk '{
    gsub("&quot;", "\"")
    print
}' |
awk -F: '
BEGIN {
    RS = ","
}
/"'"${itm}"'"/ {
    print $2
}'
