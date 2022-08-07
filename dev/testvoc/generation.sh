#!/bin/bash

set -e -u

# You can override the below variables by doing e.g.
# $ export CYCLES=1 BLOCK=1M
# before running this script.

# How many times to follow cycle when expanding with --hfst; gets slow if too high:
declare -ir CYCLES=${CYCLES-0}
# How many parallel pipelines to run (requires GNU parallel installed;
# only worth increasing if CPU's are not saturated and there's free
# RAM while running):
declare -ir J=${J-1}
# How much data to translate before restarting the pipeline (some
# pipelines have memory leaks and need restarting every so often):
declare -r BLOCK=${BLOCK:-100M}

HFST=false
UNTRIMMED=false
EXCLUDE=""
PRINT_ALL=false

show_help () {
    cat >&2 <<EOF
USAGE: $0 [ -a ] [-e 'string' ] [-u] lang1-lang2 [ source_dix ]
or:    $0 [ -a ] [-e 'string' ] --hfst lang1-lang2 foo-bar.automorf.bin

 -a, --all:       output all entries, not just errors
 -H, --hfst:      use HFST for analysis
 -e, --exclude:   exclude entries containing the specified string
 -u, --untrimmed: run the pipeline without trimming (find @, non-HFST)
 -h, --help:      show this help

Replaces the first step of the pipeline with the expanded analyser and
shows the resulting generation errors.

For example, do '$0 nno-nob' in 'apertium-nno-nob' to find
generation errors in the nno-nob direction (assumes that
modes/nno-nob.mode exists).

If the source .dix file has a non-standard name, you can specify it in
the second argument, for example '$0 eng-sco
../apertium-eng_feil/apertium-eng.eng.dix'

If you pass --hfst, the trimmed analyser will be used, and
disambiguation will be skipped. This is a lot faster, but assumes you
don't use mapping rules in CG. With --hfst, the optional dix argument
is interpreted as the analyser binary (defaulting to the first file
name of the first program of the mode).

EOF
    exit 1
}

while :; do
    if [ $# -eq 0 ]; then
        show_help
    fi
    case $1 in
        -a|--all)
            PRINT_ALL=true
            ;;
        -e|--exclude)
            if [ "$2" ]; then
                EXCLUDE="$2"
                shift
            else
                die 'ERROR: "--exclude" requires a non-empty option argument.'
            fi
            ;;
        -h|-\?|--help)
            show_help
            ;;
        -H|--hfst)
            HFST=true
            ;;
        -u|--untrimmed)
            UNTRIMMED=true
            ;;
        --)
            shift
            break
            ;;
        *)
            break
    esac
    shift
done

if [[ $# -eq 1 ]]; then
    mode=$1
    dix=guess
elif  [[ $# -eq 2 ]]; then
    mode=$1
    dix=$2
else
    show_help
fi

SRCDIR=$(pwd)
for i in {1..3}; do
    if [[ -e $SRCDIR/modes.xml ]]; then
        break
    fi
    cd '..'
    SRCDIR=$(pwd)
done

analysis_expansion () {
    # sed workaround to ignore escaped colon (lemmas may contain it and interfere with the output from lt-expand)
    lt-expand "$1" \
        | sed '/:[<>]:/b;s/\\:/§§§/g;s/:/:-:/g;s/§§§/\\:/g' \
        | awk -v clb="$2" -F':[<>\\-]:' '
          /:<:/ {next}
          $2 ~ /<compound-(R|only-L)>|DUE_TO_LT_PROC_HANG|__REGEXP__/ {next}
          {
            print "["$2"] ^"$1"/"$2"$ ^./.<sent>"clb"$"
          }'
}

analyser_to_hfst () {
    case "$(head -c4 "$1")" in
        HFST)
            hfst-fst2fst -t "$1"
            ;;
        *) # lttoolbox bin's start with their <alphabet>'s :(
            lt-print "$1" \
                | sed 's/ /@_SPACE_@/g' \
                | hfst-txt2fst -e ε
            ;;
    esac
}

analysis_expansion_hfst () {
    analyser_to_hfst "$1" \
        | hfst-project -p lower \
        | hfst-fst2strings -c"${CYCLES}"  \
        | awk -v clb="$2" '
          /[][$^{}\\]/{next} # skip escaping hell
          /<compound-(R|only-L)>|DUE_TO_LT_PROC_HANG|__REGEXP__/ {next}
          {
            gsub("]","\\]")
            print "["$0"] ^"$0"$ ^.<sent>"clb"$"
          }'
    # give the "disambiguated" output, no forms
}

only_errs () {
    # turn escaped SOLIDUS into DIVISION SLASH, so we don't grep correct stuff ("A/S" is a possible lemma)
    sed 's%\\/%∕%g' |
    if [[ $PRINT_ALL = true ]]; then
        cat
    else
        grep -e ' #' -e ' @' -e '/'
    fi
}

atfilter () {
    if [[ $UNTRIMMED = true ]]; then
        cat
    else
        grep -v '].*/@'
    fi
}

exclude_analysis () {
    if [[ "$EXCLUDE" ]]; then
        grep -v $EXCLUDE
    else
        cat
    fi
}

run_mode () {
    if command -V parallel &>/dev/null; then
        parallel -j"$J" --pipe --block "${BLOCK}" -- bash "$@"
    else
        bash "$@"
    fi
}

declare -a TMPFILES
cleanup () {
    for f in "${TMPFILES[@]}"; do
        rm -f "$f"
    done
}
trap 'cleanup' EXIT


PYTHONPATH="$(dirname "$0"):${PYTHONPATH:-}"
export PYTHONPATH
if command -V pypy3 &>/dev/null; then
    python=pypy3
else
    python=python3
fi
split_ambig=$(mktemp -t gentestvoc.XXXXXXXXXXX)
TMPFILES+=("${split_ambig}")
cat >"${split_ambig}" <<EOF
#!/usr/bin/env ${python}
import sys
import re
from streamparser import parse, reading_to_string, known
from itertools import product
for line in sys.stdin:
    line = re.sub("(?<!\\|>)\+", "\\+", line)
    units = list(parse(line, with_text=True))
    exp = []
    for unit in units:
        uniq = []
        for r in unit[1].readings:
            uniq.append((unit[0], "^{}/{}$".format(unit[1].wordform, reading_to_string(r))))
        exp.append(uniq)
    for combination in product(*exp):
        for t in combination:
            print("".join(t), end="")
        print("")
EOF
chmod +x "${split_ambig}"

split_gen=$(mktemp -t gentestvoc.XXXXXXXXXXX)
TMPFILES+=("${split_gen}")
cat >"${split_gen}" <<EOF
#!/usr/bin/env ${python}
from streamparser import parse, reading_to_string, known
import sys
import re
for line in sys.stdin:
    line = re.sub("(?<!\\|>)\+", "\\+", line)
    for blank, lu in parse(line, with_text=True):
        readings = {}
        if lu.knownness == known:
            for r in lu.readings:
                tags = "_".join(sorted(r[0].tags))
                if tags not in readings:
                    readings[tags] = r[0].baseform
                else:
                    readings[tags] += "/"+r[0].baseform
            print(blank+" ".join(readings.values()), end="")
        else:
            print(blank+reading_to_string(lu.readings[0]), end="")
    print("")
EOF
chmod +x "${split_gen}"

mode_after_analysis=$(mktemp -t gentestvoc.XXXXXXXXXXX)
TMPFILES+=("${mode_after_analysis}")
grep '|' $SRCDIR/modes/"${mode}"-biltrans.mode \
    | sed 's/[^|]*|//' \
    > "${mode_after_analysis}"

mode_after_tagger=$(mktemp -t gentestvoc.XXXXXXXXXXX)
TMPFILES+=("${mode_after_tagger}")
grep '|' $SRCDIR/modes/"${mode}"-biltrans.mode \
    | sed 's/[^|]*|//' \
    | sed 's/.*apertium-pretransfer/apertium-pretransfer/' \
    > "${mode_after_tagger}"

mode_after_bidix=$(mktemp -t gentestvoc.XXXXXXXXXXX)
TMPFILES+=("${mode_after_bidix}")
grep '|' $SRCDIR/modes/"${mode}"-dgen.mode \
    | sed "s%.*autobil.bin'* *|% ${split_ambig} |%" \
    | sed -E "s%lt-proc([^b]*)'%lt-proc\1-b '%" \
    > "${mode_after_bidix}"

lang1=${mode%%-*}

clb=""
case ${lang1} in
    nno|nob) clb="<clb>" ;;
esac

if $HFST; then
    if [[ ${dix} = guess ]]; then
        dix=$(xmllint --xpath "string(/modes/mode[@name = '${mode}']/pipeline/program[1]/file[1]/@name)" $SRCDIR/modes.xml)
    fi
    analysis_expansion_hfst "${dix}" "${clb}" \
        | exclude_analysis \
        | run_mode "${mode_after_tagger}"     \
        | run_mode "${mode_after_bidix}" \
        | ${split_gen} \
        | only_errs
else
    if [[ ${dix} = guess ]]; then
        lang1dir=$(grep -m1 "^AP_SRC.*apertium-${lang1}" $SRCDIR/config.log | sed "s/^[^=]*='//;s/'$//")
        dix=${lang1dir}/apertium-${lang1}.${lang1}.dix
        if ! [[ -e $dix ]]; then
            dix=${lang1dir}/.deps/apertium-${lang1}.${lang1}.dix
        fi
    fi
    # Make it possible to edit the .dix while testvoc is running:
    dixtmp=$(mktemp -t gentestvoc.XXXXXXXXXXX)
    TMPFILES+=("${dixtmp}")
    cat "${dix}" > "${dixtmp}"
    analysis_expansion "${dixtmp}" "${clb}" \
        | exclude_analysis \
        | run_mode "${mode_after_analysis}" \
        | atfilter \
        | run_mode "${mode_after_bidix}" \
        | ${split_gen} \
        | only_errs
fi
