#!/bin/bash
export HPGL_VERSION="1"
export HPGL_PENS="1=black:2=red:3=green:4=yellow:5=blue:6=magenta:7=cyan"
export PAGESIZE="a4,xoffset=-455mm,yoffset=-297mm"

export POST_INIT='FS1;VS20;VS4,4;VS8,5;VS8,6;' #VS4,2;VS4,7;'
#export POST_INIT='FS1;VS8;VS2,7;VS2,3;'

if ( [ ! -n "$1" ] && [ ! -n "$2" ] )
then
  echo "Usage: `basename $0` input.pdf" 1>&2
  exit -1
fi 




TEMPFILE=`tempfile`
INPUTFILE="$1"
echo Input file: $INPUTFILE  1>&2
echo Post-init commands: $POST_INIT  1>&2
pstoedit -nc -flat 0.5 -rgb -xscale 1.4111111 -yscale 1.411111 -f plot-hpgl $INPUTFILE $TEMPFILE

cat $TEMPFILE |\
	awk  '{ n = split( $0, a, ";"); for ( i = 1; i < n; i++ ) printf( "%s;\n",a[i]) }' | \
	sed '
/IN;/ a\
'"$POST_INIT"'
'
