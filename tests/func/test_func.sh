#!/bin/bash

HXTR="../../src/main/hxtr.opt"

$HXTR -ih test_func.h -tp-f test_func.tp --only f1 > _result.cmp1
$HXTR -ih test_func.h -tp-f test_func.tp --only f2 > _result.cmp2
$HXTR -ih test_func.h -tp-f test_func.tp --only f3 > _result.cmp3
$HXTR -ih test_func.h -tp-f test_func.tp --only f4 > _result.cmp4
$HXTR -ih test_func.h -tp-f test_func.tp --only f5 > _result.cmp5
$HXTR -ih test_func.h -tp-f test_func.tp --only f6 > _result.cmp6
$HXTR -ih test_func.h -tp-f test_func.tp --only f7 > _result.cmp7
$HXTR -ih test_func.h -tp-f test_func.tp --only f8 > _result.cmp8
$HXTR -ih test_func.h -tp-f test_func.tp --only f9 > _result.cmp9

R1=`cat _result.cmp1 | md5sum`
R2=`cat _result.cmp2 | md5sum`
R3=`cat _result.cmp3 | md5sum`
R4=`cat _result.cmp4 | md5sum`
R5=`cat _result.cmp5 | md5sum`
R6=`cat _result.cmp6 | md5sum`
R7=`cat _result.cmp7 | md5sum`
R8=`cat _result.cmp8 | md5sum`
R9=`cat _result.cmp9 | md5sum`

S1=`cat should.cmp1 | md5sum`
S2=`cat should.cmp2 | md5sum`
S3=`cat should.cmp3 | md5sum`
S4=`cat should.cmp4 | md5sum`
S5=`cat should.cmp5 | md5sum`
S6=`cat should.cmp6 | md5sum`
S7=`cat should.cmp7 | md5sum`
S8=`cat should.cmp8 | md5sum`
S9=`cat should.cmp9 | md5sum`

if [ "$R1" = "$S1" ]
then	echo "Test Function 1: OK"
else	echo "Test Function 1: Failed"
fi

if [ "$R2" = "$S2" ]
then	echo "Test Function 2: OK"
else	echo "Test Function 2: Failed"
fi

if [ "$R3" = "$S3" ]
then	echo "Test Function 3: OK"
else	echo "Test Function 3: Failed"
fi

if [ "$R4" = "$S4" ]
then	echo "Test Function 4: OK"
else	echo "Test Function 4: Failed"
fi

if [ "$R5" = "$S5" ]
then	echo "Test Function 5: OK"
else	echo "Test Function 5: Failed"
fi

if [ "$R6" = "$S6" ]
then	echo "Test Function 6: OK"
else	echo "Test Function 6: Failed"
fi

if [ "$R7" = "$S7" ]
then	echo "Test Function 7: OK"
else	echo "Test Function 7: Failed"
fi

if [ "$R8" = "$S8" ]
then	echo "Test Function 8: OK"
else	echo "Test Function 8: Failed"
fi

if [ "$R9" = "$S9" ]
then	echo "Test Function 9: OK"
else	echo "Test Function 9: Failed"
fi
