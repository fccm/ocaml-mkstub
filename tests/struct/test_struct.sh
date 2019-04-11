#!/bin/bash

HXTR="../../src/main/hxtr.opt"

S1="struct_first"
S2="struct_second"
S3="struct_third"
S4="struct_third_def"
S5="struct_fourth"

$HXTR -tp-s test_struct.tp -ih test_struct.h --only $S1 > _result.cmp1
$HXTR -tp-s test_struct.tp -ih test_struct.h --only $S2 > _result.cmp2
$HXTR -tp-s test_struct.tp -ih test_struct.h --only $S3 > _result.cmp3
$HXTR -tp-s test_struct.tp -ih test_struct.h --only $S4 > _result.cmp4
$HXTR -tp-s test_struct.tp -ih test_struct.h --only $S5 > _result.cmp5

R1=`cat _result.cmp1 | md5sum`
R2=`cat _result.cmp2 | md5sum`
R3=`cat _result.cmp3 | md5sum`
R4=`cat _result.cmp4 | md5sum`
R5=`cat _result.cmp5 | md5sum`

S1=`cat should.cmp1 | md5sum`
S2=`cat should.cmp2 | md5sum`
S3=`cat should.cmp3 | md5sum`
S4=`cat should.cmp4 | md5sum`
S5=`cat should.cmp5 | md5sum`

if [ "$R1" = "$S1" ]
then	echo "Test Struct 1: OK"
else	echo "Test Struct 1: Failed"
fi

if [ "$R2" = "$S2" ]
then	echo "Test Struct 2: OK"
else	echo "Test Struct 2: Failed"
fi

if [ "$R3" = "$S3" ]
then	echo "Test Struct 3: OK"
else	echo "Test Struct 3: Failed"
fi

if [ "$R4" = "$S4" ]
then	echo "Test Struct 4: OK"
else	echo "Test Struct 4: Failed"
fi

if [ "$R5" = "$S5" ]
then	echo "Test Struct 5: OK"
else	echo "Test Struct 5: Failed"
fi
