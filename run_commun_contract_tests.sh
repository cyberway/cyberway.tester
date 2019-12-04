#!/bin/bash

dir=$(dirname "$0")

pushd $dir/commun.contracts

echo --------------------Building image---------------------

/bin/bash .buildkite/steps/build-image.sh 

echo ----------------Executing deploy tests-----------------

/bin/bash .buildkite/steps/deploy-test.sh 

deploy_test_result=$?

echo Tests exit status: $deploy_test_result 

echo ----------------Executing unit tests-------------------

/bin/bash .buildkite/steps/unit-test.sh 

unit_test_result=$?

popd

echo Tests exit status: $unit_test_result 

result=$(( $deploy_test_result || $unit_test_result ))

exit $result
