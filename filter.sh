case $# in
  3)
    LANG=$1
    SIDE=$2
    ;;
  *)
    echo "USAGE: fixvariants.sh LANG SIDE FILE";
    echo "With SIDE one of 'left' or 'right'";
    exit 1;
esac

xsltproc --stringparam lang $LANG --stringparam side $SIDE filter.xsl $3

