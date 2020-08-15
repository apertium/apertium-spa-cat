#!/bin/bash

if  [[ $# -eq 2 ]]; then
    MODE=$1
    MONODIX=$2
elif  [[ $# -eq 3 ]]; then
    MODE=$2
    MONODIX=$3
else
    cat >&2 <<EOF
Usage: $0 [-e] <direction> <monodix>

<direction> is the pair direction to be tested.
<monodix> is the path to the source language monolingual dictionary. Set to "auto" for autodetection.

Use the -e flag to skip testing on enclitics, which slow down the process.

Example: $0 -e eng-cat ../../../apertium-eng/apertium-eng.eng.dix

EOF
    exit 1
fi

TRIMMED=true

while getopts "et" opt; do
  case $opt in
    e)
      ENCLITICS=true
      ;;
    t)
      TRIMMED=false
      ;;
  esac
done

expand_poly () {
    sed 's/>\/\([^/]\)/>\/\/\1/g' | sed 's/<sent>\/\//<sent>\/~\//g' > $POLY1
    for (( i=0; i<50; i++ )) do  # This runs for a limited number of iterations to avoid endless loops
        if ! grep -q "//" $POLY; then
            break
        fi
        cat $POLY1 | 
        awk '# This program expands polysemic entries into multiple lines
        # so each possibility is tested during testvoc. Each time
        # it is executed, an entry per line is modified if necessary.

        BEGIN { FS="\\$ "; OFS = "$ " }
        {
            if ($2 !="")
            {
                first = $1;
                $1 = "";
                j=split(first, a, "//");
                for (i = 2; i <= j; ++i) print a[1] "/~/" a[i] "$+" substr($0,3,length($0));
            }
            else print $0;
        }' > $POLY2
        mv $POLY2 $POLY1
    done
    cat $POLY1 | sed 's/\/\//\//g' | sed "s|>/~/|>/|g" | sed "s|\$+\^|$ ^|g"
}

trim () {
    if [[ $TRIMMED = true ]]; then
        grep -v '>/@'
    else
        cat
    fi
}

LANG1=$(sed 's/-.*//' <<< $MODE)
LANG2=$(sed 's/.*-//' <<< $MODE)
SRCDIR=$(grep -m1 "^abs_srcdir =" ../../Makefile | sed "s/^.*= //")
LANG1DIR=$(cd $SRCDIR; cd $(grep -m1 "^AP_SRC.*apertium-${LANG1}" Makefile | sed "s/^.*= //") && pwd)
MODE=$SRCDIR"/modes/$MODE.mode"

if ! [[ -e $MODE ]]; then
    echo "Mode file ($MODE) not found."
    exit 1
else
    if ! [[ $(grep 'apertium-pretransfer' $MODE) ]]; then
        echo "Mode file ($MODE) does not seem to contain a valid Apertium pipeline."
        exit 1
    else
        PIPELINE_ALL=$(grep -m1 'apertium-pretransfer' $MODE |\
        sed 's/.*apertium-pretransfer/apertium-pretransfer/' |\
        sed "s%\ lrx-proc[^|]*|%%" |\
        sed "s%\ lt-proc \$1%\ lt-proc -d%")
        PIPELINE_LEX=$(mktemp -t testvoc.XXXXXXXXXXX)
        PIPELINE_TFR=$(mktemp -t testvoc.XXXXXXXXXXX)
        PIPELINE_GEN=$(mktemp -t testvoc.XXXXXXXXXXX)
        echo $PIPELINE_ALL | sed "s%lt-proc -b\([^|]*\)|.*%lt-proc -b\1%" > "$PIPELINE_LEX"
        echo $PIPELINE_ALL | sed "s%.*lt-proc -b\([^|]*\)|\(.*\)%\2%" | sed "s/| lt-proc -d.*//" > "$PIPELINE_TFR"
        echo $PIPELINE_ALL | sed 's/.*lt-proc -d/lt-proc -d/' > "$PIPELINE_GEN"
        TMPFILES+=("$PIPELINE_LEX" "$PIPELINE_TFR" "$PIPELINE_GEN")
    fi
fi

if [[ $MONODIX != "auto" ]]; then
    if ! [[ -e $MONODIX ]]; then
        echo "Monolingual dictionary ($MODE) not found."
        exit 1
    fi
else
    MONODIX="$LANG1DIR/apertium-$LANG1.$LANG1.dix"
    if ! [[ -e $MONODIX ]]; then
        MONODIX="$LANG1DIR/.deps/apertium-$LANG1.$LANG1.dix"
        if ! [[ -e $MONODIX ]]; then
            echo "Monolingual dictionary ($MONODIX) not found."
            exit 1
        fi
    fi
fi

POLY1=$(mktemp .testvoc.XXXXXXXXXXX)  # These two are created in the working directory, because they tend to grow very big and may fill /tmp
POLY2=$(mktemp .testvoc.XXXXXXXXXXX)
TMPFILES+=("$POLY1" "$POLY2")

lt-expand $MONODIX | grep -v 'REGEX' | grep -v ':<:' |  # The monodix is expanded, regular expressions and "RL" entries are removed
( [[ $ENCLITICS ]] && grep -v '<prn><enc>' || cat ) |  # If the -e flag is used, enclitics are removed for faster processing
sed 's/:>:/\'$'\t/g' | sed 's/:/\'$'\t/g' | cut -f2 -d$'\t' |  # Surface forms are removed
sed 's/^/^/g' | sed 's/\(.*\)/[\\\1\$]\1/g' | sed 's/$/$ ^.<sent>$/g' |  # Entries are converted to Apertium pipeline format, preceded by the source form and followed by a full stop
bash "$PIPELINE_LEX" |  # Lexical transfer takes place
trim |  # The list of entries is trimmed according to the bidix
expand_poly |  # Polysemic entries are expanded into multiple lines
bash "$PIPELINE_TFR" |  # Structural transfer takes place
bash "$PIPELINE_GEN" |  # Target language surface forms are generated
sed 's/^\[\\\(.*\)\$\]/\1\$ _ /g' | sed 's/ \^.<sent>\$//g' | sed 's/ \.//g' | sed 's/ _ /   --------->   /g'

for f in "${TMPFILES[@]}"; do
    rm -f "$f"
done

exit 0
