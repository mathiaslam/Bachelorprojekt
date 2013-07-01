#!/bin/bash
export HPGL_VERSION="1"
export HPGL_PENS="1=black:2=red:3=green:4=yellow:5=blue:6=magenta:7=cyan"
export PAGESIZE="a4,xoffset=-331mm,yoffset=-212mm"

export POST_INIT='FS4;VS10;VS10,1;FS4,1;VS20,2;VS6,5;VS10,3;VS4,1;' #VS4,2;VS4,7;'
#export POST_INIT='FS1;VS8;VS2,7;VS2,3;'

if ( [ ! -n "$1" ] && [ ! -n "$2" ] )
then
  echo "Usage: `basename $0` input.pdf" 1>&2
  exit -1
fi 




TEMPFILE=`mktemp`
INPUTFILE="$1"

echo Input file: $INPUTFILE  1>&2
echo Post-init commands: $POST_INIT  1>&2
pstoedit -nc -flat 0.5 -rgb -xscale 1.4111111 -yscale 1.4111111 -f plot-hpgl $INPUTFILE $TEMPFILE

cat $TEMPFILE |\
	awk  '{ n = split( $0, a, ";"); for ( i = 1; i < n; i++ ) printf( "%s;\n",a[i]) }' | \
	sed '
/IN;/ a\
'"$POST_INIT"'
'
