#!/usr/bin/awk -f

BEGIN{
    FS = "="
}

{
    car[$1] = $2
}

function getVehicleInfoAttr (attrName,
                             getAttrFmt, getAttr, attrVal) {
    getAttrFmt = "echo \"%s\" | bin/vinfo-helper.sh %s"
    getAttr = sprintf(getAttrFmt, car["vehicleInfo"], attrName)
    getAttr | getline attrVal
    close(getAttr)
    gsub("\"", "", attrVal)
    return(attrVal)
}

END {
    if (getVehicleInfoAttr("IsTransferable") == "true") {
        extcolor = getVehicleInfoAttr("ExteriorColor")
        intcolor = getVehicleInfoAttr("InteriorColor")
        color    = extcolor "/" intcolor
        desc     = "\"" car["year"] " " car["makeModelTrim"] " (" car["miles"] " miles, " color ")\""
        asking   = car["price"]
        transfer = car["transferAmount"]
        mileage  = getVehicleInfoAttr("Mileage")
        url      = "https://www.carmax.com/car/" car["stockNumber"]
        print ":desc", desc, ":asking", asking, ":transfer", transfer, ":mileage", mileage, ":url", url
    }
}
