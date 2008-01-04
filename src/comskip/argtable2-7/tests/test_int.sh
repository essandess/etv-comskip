#!/bin/sh

fail ()
    { 
    echo "$0 TESTS FAILED";
    exit 1;
    }

echo $0 TESTS BEGIN

#these tests should all return zero (parse succeeded)
./test_int --help || fail
./test_int 0 || fail
./test_int 1 -- -1 || fail
./test_int 1 2 -- -3 || fail
./test_int 5 7 9 -d -21 || fail
./test_int -d 1 -D 1 --delta 1 -- -3 || fail
./test_int 1 2 4 --eps -7 || fail
./test_int 1 2 4 --eqn -7 || fail
./test_int 1 2 3 -D4 --eps -10 || fail
./test_int 1 -f || fail
./test_int -f 1 || fail
./test_int -f 2 --filler || fail
./test_int -f 1 --filler=1 -f || fail

#these tests should all return non-zero (parse failed)
./test_int && fail
./test_int 1 2 3 4 && fail
./test_int 1 2 3 -d1 -d2 -d3 -d4 && fail
./test_int 1 2 3 --eps && fail
./test_int 1 2 3 --eps 3 --eqn 6 && fail
./test_int hello && fail
./test_int 1.234 && fail
./test_int 4 hello && fail
./test_int 5 1.234 && fail
./test_int -f 2 --filler= && fail

echo "$0 TESTS PASSED"
echo "----------------------------------"

