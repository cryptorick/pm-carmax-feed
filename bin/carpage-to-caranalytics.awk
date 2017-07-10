#!/usr/bin/awk -f

BEGIN {
    FS="[<>\"]"
    RS=">[ \t\n]*<"
}

/span data-prop=/ {
    printf("%s=", $3)
    getline
    print $1
}
