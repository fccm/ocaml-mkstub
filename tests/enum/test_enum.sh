#!/bin/bash

HXTR="../../src/main/hxtr.opt"

E1="e_first"
E2="e_second"
E3="e_third"
E4="e_third_t"

$HXTR -tp-e test_enum.tp -ih test_enum.h --only $E1 > _result.cmp1
$HXTR -tp-e test_enum.tp -ih test_enum.h --only $E2 > _result.cmp2
$HXTR -tp-e test_enum.tp -ih test_enum.h --only $E3 > _result.cmp3
$HXTR -tp-e test_enum.tp -ih test_enum.h --only $E4 > _result.cmp4

R1=`cat _result.cmp1 | md5sum`
R2=`cat _result.cmp2 | md5sum`
R3=`cat _result.cmp3 | md5sum`
R4=`cat _result.cmp4 | md5sum`

S1=`cat should.cmp1 | md5sum`
S2=`cat should.cmp2 | md5sum`
S3=`cat should.cmp3 | md5sum`
S4=`cat should.cmp4 | md5sum`

if [ "$R1" = "$S1" ]
then	echo "Test Enum 1: OK"
else	echo "Test Enum 1: Failed"
fi

if [ "$R2" = "$S2" ]
then	echo "Test Enum 2: OK"
else	echo "Test Enum 2: Failed"
fi

if [ "$R3" = "$S3" ]
then	echo "Test Enum 3: OK"
else	echo "Test Enum 3: Failed"
fi

if [ "$R4" = "$S4" ]
then	echo "Test Enum 4: OK"
else	echo "Test Enum 4: Failed"
fi
