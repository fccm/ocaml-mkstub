#!/bin/bash

#TESTS="enum struct func union nested object"
TESTS="enum struct func union nested"

for tt in $TESTS
do
      pushd $tt   > /dev/null 2>&1
      make test  2> /dev/null | grep -E '(OK|Failed)' --color=always
      make clean  > /dev/null 2>&1
      popd        > /dev/null 2>&1
done
