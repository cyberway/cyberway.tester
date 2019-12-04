#!/bin/bash

#set -euo pipefail

dir=$(dirname "$0")

export BUILDKITE_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo Building branch $BUILDKITE_BRANCH

failed=""

echo ==== Starting cyberway system contracts tests ====

$dir/run_cyberway_contract_tests.sh | tee cyberway_contracts_tests.log

cyberway_contracts_result=${PIPESTATUS[0]}

if [ $cyberway_contracts_result -ne 0 ]; then failed=$(printf "Cyberway system contracts tests\n"); fi

echo ==== Starting commun dapp conracts tests ====

$dir/run_commun_contract_tests.sh | tee commun_contracts_tests.log

commun_contracts_result=${PIPESTATUS[0]}

if [ $commun_contracts_result -ne 0 ]; then failed=$(printf $failed"Commun dapp contracts tests\n"); fi

echo ==== Starting golos dapp conracts tests ====

$dir/run_golos_contract_tests.sh | tee golos_contracts_tests.log

golos_contracts_result=${PIPESTATUS[0]}

if [ $golos_contracts_result -ne 0 ]; then failed=$(printf $failed"Golos dapp contracts tests\n"); fi

echo ==== Starting cyberway tests ====

#$dir/run_cyberway_tests.sh  | tee cyberway_tests.log

#cyberway_result=${PIPESTATUS[0]}

cyberway_result=0

if [ $cyberway_result -ne 0 ]; then failed=$(printf $failed"Cyberway tests\n"); fi

result=$(($cyberway_contracts_result || $commun_contracts_result || $golos_contracts_result || $cyberway_result))


if [ $result -ne 0 ]; then
    echo -e "\e[31mTesting failed:"
    echo   $failed
else
    echo -e "\e[32mTesting successful"
fi

echo -e "\e[0m"
