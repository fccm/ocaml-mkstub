#!/bin/bash

HXTR="../../src/main/hxtr.opt"

U1="my_un1"
U2="my_un2"
U3="my_un3"

$HXTR -tp-u test_union.tp -ih test_union.h --only $U1 > _result.cmp1
$HXTR -tp-u test_union.tp -ih test_union.h --only $U2 > _result.cmp2
$HXTR -tp-u test_union.tp -ih test_union.h --only $U3 > _result.cmp3

R1=`cat _result.cmp1 | md5sum`
R2=`cat _result.cmp2 | md5sum`
R3=`cat _result.cmp3 | md5sum`

S1=`cat should.cmp1 | md5sum`
S2=`cat should.cmp2 | md5sum`
S3=`cat should.cmp3 | md5sum`

if [ "$R1" = "$S1" ]
then	echo "Test Union 1: OK"
else	echo "Test Union 1: Failed"
fi

if [ "$R2" = "$S2" ]
then	echo "Test Union 2: OK"
else	echo "Test Union 2: Failed"
fi

if [ "$R3" = "$S3" ]
then	echo "Test Union 3: OK"
else	echo "Test Union 3: Failed"
fi
