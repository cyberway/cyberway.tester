#!/bin/bash

dir=$(dirname "$0")

pushd $dir/golos.contracts

echo --------------------Building image---------------------

/bin/bash .buildkite/steps/build-image.sh 

echo ----------------Executing unit tests-------------------

/bin/bash .buildkite/steps/deploy-test.sh 

result=$?

popd

echo Tests exit status: $result 

exit $result
