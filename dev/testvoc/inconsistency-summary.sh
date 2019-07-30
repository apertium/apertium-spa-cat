#!/bin/bash

IFS=","
INC=$1
PAIR=$2
OUT=testvoc-summary.$PAIR.txt
POS=($(grep -m 1 "^POS=" testvoc.conf | cut -d = -f 2))
unset IFS

echo -n "" > $OUT;

date >> $OUT
echo -e "================================================" >> $OUT
echo -e "POS\tTotal\tClean\tWith @\tWith #\tClean %" >> $OUT
for i in "${!POS[@]}"; do
	CONFIG=$(grep -m 1 "^Exclude_${POS[$i]}=" testvoc.conf | cut -d = -f 2)
	if ! [ -z "$CONFIG" ]; then
		CONFIG=$(sed "s/,/ -e /g" <<< $CONFIG)
		ALL=$(cat $INC | grep "<${POS[$i]}>" | grep -v REGEX | grep -v -e $CONFIG);
		TOTAL=$(cat $INC | grep "<${POS[$i]}>" | grep -v REGEX | grep -v -e $CONFIG | wc -l);
		AT=$(cat $INC | grep "<${POS[$i]}>" | grep -v REGEX | grep -v -e $CONFIG | grep ' \\@' | wc -l);
		HASH=$(cat $INC | grep "<${POS[$i]}>" | grep -v REGEX | grep -v -e $CONFIG | grep ' #' | wc -l);
	else
		ALL=$(cat $INC | grep "<${POS[$i]}>" | grep -v REGEX);
		TOTAL=$(cat $INC | grep "<${POS[$i]}>" | grep -v REGEX | wc -l);
		AT=$(cat $INC | grep "<${POS[$i]}>" | grep -v REGEX | grep ' \\@' | wc -l);
		HASH=$(cat $INC | grep "<${POS[$i]}>" | grep -v REGEX | grep ' #' | wc -l);
	fi
	UNCLEAN=`bc <<< $AT+$HASH`;
	CLEAN=`bc <<< $TOTAL-$UNCLEAN`;
	PERCLEAN=`calc $UNCLEAN/$TOTAL*100 | sed 's/^\W*//g' | sed 's/~//g' | head -c 5`;
	echo $PERCLEAN | grep "Err" > /dev/null;
	if [ $? -eq 0 ]; then
		TOTPERCLEAN="100";
	else
		TOTPERCLEAN=`echo 100-$PERCLEAN | bc | sed 's/^\W*//g' | sed 's/~//g' | head -c 5`;
	fi

	if [ $TOTAL -gt 0 ]; then echo -e $TOTAL";"${POS[$i]}";"$CLEAN";"$AT";"$HASH";"$TOTPERCLEAN; fi
done | sort -gr | awk -F';' '{print $2"\t"$1"\t"$3"\t"$4"\t"$5"\t"$6}' >> $OUT

echo -e "================================================" >> $OUT
cat $OUT;
