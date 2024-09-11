#!/bin/bash

solve_power_sequence() {
    local max=$1
    declare -A results # Use an associative array to track unique results

    for ((a=2; a<=max; a++)); do
        for ((b=2; b<=max; b++)); do
            result=$(echo "$a^$b" | bc) # Calculate power using bc
            results["$result"]=1 # Store result in associative array, key is the result itself
        done
    done

    echo "${#results[@]}" # Output the number of unique results
}

result=$(solve_power_sequence 100)
echo "Number of distinct terms for 2 ≤ a ≤ 100 and 2 ≤ b ≤ 100: $result"

test_cases() {
    local expected=$1
    local max=$2
    local result=$(solve_power_sequence $max)

    if [ "$result" -eq "$expected" ]; then
        echo "Test case for max=$max: PASSED (Expected: $expected, Got: $result)"
    else
        echo "Test case for max=$max: FAILED (Expected: $expected, Got: $result)"
    fi
}

test_cases 15 5
test_cases 69 10
test_cases 177 15
test_cases 9183 100

if [ "$result" -eq 9183 ]; then
    echo "Main problem result verified: PASSED"
else
    echo "Main problem result verification: FAILED (Expected: 9183, Got: $result)"
fi
