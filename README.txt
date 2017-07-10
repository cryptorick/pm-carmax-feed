Poor Man's Carmax Feed

This is super-lame, one-off and a bit manual, but it worked for what I
needed.  This is here not only for you to laugh, but for me to
remember what I did.  I doubt I will revisit this to improve it.

Directions

Step 1.  Run search in carmax.com and save the page (Ctrl-S) to a file
named (for instance) carmax-page-01.html.  (Yeah, I think a straight
pull from curl wasn't working for me.  Didn't investigate why; just
moved on.)

Step 2.  Process this cached page with the following command which
harvests out the stock numbers in your search.

$ awk -F'[<>]' 'BEGIN{RS=">[ \t\n]*<"}/div class="vehicle-browse--result"/' carmax-page-01.html | xargs -n1 | awk -F= '/data-stock-number/{print $2}' > stock-numbers
$ cat stock-numbers
14707381
14670626
14688491
14834644
14708942
14764564
14603211
14245388
14732555
14804050

Step 2.71828...  Setup a cookie file.  You need to do this to tell
Carmax where "Your Store" is located, so that it can compute the
transfer fees correctly (and if it can even be transferred).  If you
don't do this, you will lose visibility on the transfer info and could
possibly be looking at ineligible cars, i.e., it will be at least an
inconvenience.  In our case, "Your Store" is in Indianapolis.

$ curl -b cookie-file -O https://www.carmax.com
$ vi cookie-file

Now go to the line for cookie name "KmxVisitor_0" and ensure the
following query variables have the values indicated here:

  - FirstVisit=False
  - Zip=46280
  - StoreId=7144
  - ZipConfirmed=True

Step 3.  Cache each car's (stock number's) page.

$ (mkdir -p carpage-cache && cd carpage-cache && cat ../stock-numbers | while read sn; do echo $sn; curl -b ../cookie-file -c ../cookie-file -O https://www.carmax.com/car/$sn 2>/dev/null; done)

Step 4.  Run the whole enchilada.

$ bin/print-plists-from-carpage-cache.sh

Step 4a. This is good for email messages.

$ bin/print-plists-from-carpage-cache.sh | awk '{sub(":desc \"","");sub("\" :asking","\nAsking:");sub(":transfer",", Transfer:");sub(":mileage",", Mileage:");sub(" :url ","\n");print $0 "\n"}'

____________________
Extra 1.  Non caching example

$ curl -b cookie-file -c cookie-file https://www.carmax.com/car/14707381 2>/dev/null | bin/carpage-to-caranalytics.awk | bin/caranalytics-to-plist.awk
:desc "2015 Subaru Forester 2.5i Limited (32K miles, Blue/Gray)" :asking 22998 :transfer 799 :mileage 31086 :url https://www.carmax.com/car/14707381
