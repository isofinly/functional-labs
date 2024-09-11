#!/bin/bash

MAX_VALUE=4000000

EXPECTED_RESULT=4613732

function solve_euler2 {
    a=1
    b=2
    sum=2

    while [ $b -le $MAX_VALUE ]; do
        c=$((a + b))

        if [ $((c % 2)) -eq 0 ]; then
            sum=$((sum + c))
        fi

        a=$b
        b=$c
    done

    echo "The sum of the even-valued Fibonacci terms up to $MAX_VALUE is: $sum"
}

function test_euler2 {
    local result=$(solve_euler2)
    local actual_result=$(echo "$result" | awk -F': ' '{print $2}')

    if [ "$actual_result" -eq "$EXPECTED_RESULT" ]; then
        echo "Test passed!"
    else
        echo "Test failed! Expected result: $EXPECTED_RESULT, Actual result: $actual_result"
    fi
}

solve_euler2
test_euler2