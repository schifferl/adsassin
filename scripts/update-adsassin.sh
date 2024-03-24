#!/bin/sh
URL1='https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&mimetype=plaintext'
URL2='https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts'
URL3='https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt'
URL4='https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt'
URL5='https://v.firebog.net/hosts/Easylist.txt'
URL6='https://v.firebog.net/hosts/Easyprivacy.txt'
URL7='https://blocklistproject.github.io/Lists/ads.txt'
URL8='https://raw.githubusercontent.com/ProgramComputer/Easylist_adservers_hosts/main/hosts'
TEMP="$(mktemp)"

wget -q -O - $URL1 | dos2unix >> $TEMP
wget -q -O - $URL2 | dos2unix >> $TEMP
wget -q -O - $URL3 | dos2unix >> $TEMP
wget -q -O - $URL4 | dos2unix >> $TEMP
wget -q -O - $URL5 | dos2unix >> $TEMP
wget -q -O - $URL6 | dos2unix >> $TEMP
wget -q -O - $URL7 | dos2unix >> $TEMP
wget -q -O - $URL8 | dos2unix >> $TEMP

sed -e '/^#/d' \
    -e 's/#.*//' \
    -e 's/^[ 	]*//' \
    -e 's/[ 	]*$//' \
    -e '/^$/d' \
    -e 's/	/ /' \
    -e 's/^0.0.0.0 //' \
    -e 's/^127.0.0.1 //' \
    -e 's/^255.255.255.255 //' \
    -e '/^0.0.0.0$/d' \
    -e '/broadcasthost$/d' \
    -e '/ip6-localhost$/d' \
    -e '/ip6-loopback$/d' \
    -e '/ip6-localnet$/d' \
    -e '/ip6-mcastprefix$/d' \
    -e '/ip6-allnodes$/d' \
    -e '/ip6-allrouters$/d' \
    -e '/ip6-allhosts$/d' \
    -e '/ip6-allnodes$/d' \
    -e '/localhost$/d' \
    -e '/localdomain$/d' \
    -e '/^_/d' \
    -e 's/^/0.0.0.0 /' \
    $TEMP | sort -u -b -f -i > adsassin.txt

printf '{\n' > adsassin.lsrules
printf '  "name": "Adsassin",\n' >> adsassin.lsrules
printf '  "description": "A Meta-Block List with Daily Updates",\n' >> adsassin.lsrules
printf '  "denied-remote-domains": [\n' >> adsassin.lsrules

sed -e 's/^0.0.0.0 /    "/' \
    -e 's/$/"/' \
    -e '$!s/$/,/' \
    adsassin.txt >> adsassin.lsrules

printf '  ]\n' >> adsassin.lsrules
printf '}\n' >> adsassin.lsrules
