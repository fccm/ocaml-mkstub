#!/bin/sh

HXTR="../hxtr/hxtr.opt"

OUT="`basename $1 .h`.list"

if [ "$2" != "" ]
then
	OUT="$2"
fi

echo "$HXTR -ih $1 -tp-f ../templates/utils/make_exclude.tp > '$OUT'"

$HXTR -ih $1 \
   -tp-f ../templates/utils/make_exclude.tp \
    > "$OUT" 2> /dev/null
