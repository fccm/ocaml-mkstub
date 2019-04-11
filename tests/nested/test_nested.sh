#!/bin/bash

HXTR="../../src/main/hxtr.opt"

N1="output"
N2="token"

TP_U="../union/test_union.tp"
TP_S="../struct/test_struct.tp"

$HXTR -tp-u $TP_U -ih test_nested.h --only $N1 > _result.cmp1
$HXTR -tp-u $TP_S -ih test_nested.h --only $N2 > _result.cmp2

R1=`cat _result.cmp1 | md5sum`
R2=`cat _result.cmp2 | md5sum`

S1=`cat should.cmp1 | md5sum`
S2=`cat should.cmp2 | md5sum`

if [ "$R1" = "$S1" ]
then	echo "Test Nested 1: OK"
else	echo "Test Nested 1: Failed"
fi

if [ "$R2" = "$S2" ]
then	echo "Test Nested 2: OK"
else	echo "Test Nested 2: Failed"
fi
