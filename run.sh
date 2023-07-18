#!/bin/bash
NC="\e[0m"
GR="\e[0;32m"
YL="\e[0;33m"
CY="\e[0;36m"

shred -u -f Scope.ods domains.txt Scope.csv 2> /dev/null &> /dev/null
url=$(echo -e "https://www.communicatierijk.nl$(curl -ks https://www.communicatierijk.nl/vakkennis/r/rijkswebsites/verplichte-richtlijnen/websiteregister-rijksoverheid | grep ".ods" | sed -n 's/.*href="\([^"]*\).*/\1/p')")

echo -e "FILE PATH:$CY $url $NC"
wget -O Scope.ods $url &> /dev/null
libreoffice --convert-to csv Scope.ods --headless 2> /dev/null &> /dev/null
cat Scope.csv | tr ',' ' ' | awk '{print $1}' | sed 's/http:\/\/\|https:\/\///g' | sed -e '1,2d' | sed 's/\/.*//' | sed '/\.\([^\.]*\.\)/s/^[^.]*\.//' | sort -u | uniq -u > domains.txt
sleep 2s
echo ""
echo -e "Total number subdomains found:$GR $(cat domains.txt | wc -l) $NC\n"
echo -e "The list of In-Scope domains are saved in:$YL $(pwd)/domains.txt $NC\n"

