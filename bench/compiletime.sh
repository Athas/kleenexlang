#! /bin/bash
# Measure compile times.

# Assumes a link to the binary in ../repgbin
REPGC=../repgbin
HASDIR=hased_src/
OPT_LEVELS=(1 2 3)
CCS=(gcc gcc-mp-4.9)
REPS=1
BIN_POSTFIX=".benchbin"
BIN_DIR="bin/"
OUT_DIR="compiletimes/"
COMPILETIME_POSTFIX=".compiletime"
NAME=""
SKIP="issuu"
# SKIP="NONE" 

# Args: file name, opt level, C compiler
function setname {
    NAME="${1}__${2}__${3}"
}

function areyousure {
    while true; do
        read -p "This will clear old data in $OUT_DIR.  Proceed? " yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

cleardata=false
while getopts ":c" opt; do
  case $opt in
  c)
      cleardata=true
      areyousure
      ;;
  \?)
      echo "Invalid option: -$OPTARG" >&2
      exit
      ;;
  esac
done

for opt_level in ${OPT_LEVELS[@]}; do
    for cc in ${CCS[@]}; do
        for n in $(ls $HASDIR); do
            if [[ ${n} !=  ${SKIP}* ]]; then
                setname $n $opt_level $cc
                timingdata=$OUT_DIR$NAME$COMPILETIME_POSTFIX
                if [ "$cleardata" = true ]; then
                    cat /dev/null > $timingdata
                fi
                for i in `seq 1 $REPS`; do
                    binary=$BIN_DIR$NAME #$BIN_POSTFIX
                    CMD="$REPGC compile $HASDIR$n --out $binary --opt $opt_level --cc $cc >> $timingdata"
                    echo $i
                    echo $CMD
                    eval "$CMD"
                    echo ""
                done
            fi
        done
    done
done
