#!/bin/bash
export HPGL_VERSION="1"
export HPGL_PENS="1=black:2=red:3=green:4=yellow:5=blue:6=magenta:7=cyan"
export PAGESIZE="a4"
export ROTATION="0"

export POST_INIT='FS1;VS20;FS1,1;VS20,1;FS1,2;VS20,2;VS10,3;FS1,3;'

if ( [ ! -n "$1" ] && [ ! -n "$2" ] )
then
  echo "Usage: `basename $0` input.pdf" 1>&2
  exit -1
fi 

TEMPFILE=`mktemp /tmp/${tempfoo}.XXXXXX` || exit 1
INPUTFILE="$1"
echo Input file: $INPUTFILE  1>&2
echo Post-init commands: $POST_INIT  1>&2
pstoedit -nc -flat 0.5 -rgb -xshift -137 -yshift -44 -xscale 1.4111111 -yscale 1.411111 -f plot-hpgl $INPUTFILE $TEMPFILE

cat $TEMPFILE |\
	awk  '{ n = split( $0, a, ";"); for ( i = 1; i < n; i++ ) printf( "%s;\n",a[i]) }' | \
	sed '
/IN;/ a\
'"$POST_INIT"'
'
