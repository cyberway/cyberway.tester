#!/bin/bash

dir=$(dirname "$0")

echo ----------------Executing python tests---------------

/bin/bash $dir/cyberway.build.tests/python-tests.sh 

python_test_result=$?

echo Tests exit status: $python_test_result

echo ----------------Executing deploy tests-----------

pushd $dir/cyberway

/bin/bash .buildkite/steps/deploy-test.sh 

deploy_test_result=$?

echo Tests exit status: $deploy_test_result

echo ----------------Executing core unit tests-----------

/bin/bash .buildkite/steps/deploy-unit_test.sh 

core_unit_test_result=$?

echo Tests exit status: $core_unit_test_result

echo ----------------Executing api tests-----------------

/bin/bash .buildkite/steps/api-test.sh 

api_test_result=$?

echo Tests exit status: $api_test_result

result=$(($python_test_result || $deploy_test_result || $core_unit_test_result || $api_test_result))

popd

exit $result
