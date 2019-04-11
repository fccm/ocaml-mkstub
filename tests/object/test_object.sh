#!/bin/bash

HXTR="../../src/main/hxtr.opt"

O1="rect1"
O2="rect2"
O2="rect3"

$HXTR -ih test_object.h -tp-s test_object.tp --only $O1 > _result.cmp1
$HXTR -ih test_object.h -tp-s test_object.tp --only $O2 > _result.cmp2
$HXTR -ih test_object.h -tp-s test_object.tp --only $O3 > _result.cmp3

R1=`cat _result.cmp1 | md5sum`
R2=`cat _result.cmp2 | md5sum`
R3=`cat _result.cmp3 | md5sum`

S1=`cat should.cmp1 | md5sum`
S2=`cat should.cmp2 | md5sum`
S3=`cat should.cmp3 | md5sum`

if [ "$R1" = "$S1" ]
then	echo "Test Object 1: OK"
else	echo "Test Object 1: Failed"
fi

if [ "$R2" = "$S2" ]
then	echo "Test Object 2: OK"
else	echo "Test Object 2: Failed"
fi

if [ "$R3" = "$S3" ]
then	echo "Test Object 3: OK"
else	echo "Test Object 3: Failed"
fi
