#!/bin/bash

projects=("cyberway":"build-only-cyberway-image" \
          "cyberway.cdt":"create-cdt-image" \
          "cyberway.contracts":"create-cyberway-dot-contracts-image" \
          "cyberway":"test-only-cyberway-image"
#          "commun.contracts":"create-commun-dot-contracts" \
#          "golos.contracts":"create-golos-dot-contracts-image" \
          )

cdt_revision=$(git -C "cyberway.cdt" rev-parse HEAD)
cw_revision=$(git -C "cyberway" rev-parse HEAD)
cw_contracts_revision=$(git -C "cyberway.contracts" rev-parse HEAD)

echo "steps:"

for project in "${projects[@]}"; do
    
    name=`echo $project | awk -F: ' { print $1 } ' `
    buildkite_slug=`echo $project | awk -F: ' { print $2 } ' `

    project_revision=$(git -C $name rev-parse HEAD)

    echo "    - label: \":pipeline: Execute ${buildkite_slug} pipeline\""
    echo "      trigger: \"${buildkite_slug}\""
    echo "      build:"
    echo "          env:"
    echo "              CDT_TAG: \"$cdt_revision\""
    echo "              BUILDER_TAG: \"$cw_revision\""
    echo "              CW_TAG: \"$cw_revision\""
    echo "              SYSTEM_CONTRACTS_TAG: \"$cw_contracts_revision\""
    echo "          commit: \"$project_revision\""
    echo "          message: \"${BUILDKITE_MESSAGE}\""
    echo "          branch: \"$project_revision\""
    echo "    - wait"
done