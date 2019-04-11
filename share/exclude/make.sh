#!/bin/sh

mkdir -p std_h

for HEAD in `cat std_list`
do
	OUT=`echo $HEAD | sed -e 's:/:_:g'`
	OUT="./std_h/inc_$OUT"
	echo "#include <$HEAD>" > $OUT
	echo "$OUT written"
done

mkdir -p std_exclu

for h in std_h/*.h
do
	out="`basename $h .h`.exclu"
	out="`echo $out | sed -e 's/inc_//'`"
	out="std_exclu/$out"
	echo sh mkexclude.sh  $h $out 
	     sh mkexclude.sh  $h $out 
	echo "$out written"
done
