#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BASE_DIR=$( echo $SCRIPT_DIR | sed 's/\/bin//g')
EXECUTION_DIR="$(pwd)"
cd "${BASE_DIR}/data/fhir/bulk"

# Download and Unzip
if [ ! -f coherent-11-07-2022.zip ]; then
  wget https://synthea-open-data.s3.amazonaws.com/coherent/coherent-11-07-2022.zip 
fi
unzip -j coherent-11-07-2022.zip "fhir/*.json" -d .
# Cleanup
rm coherent-11-07-2022.zip
# Removing duplicates; these are curated in the git:healthcare-api-101/data/fhir/bundle
# directory
rm organizations.json
rm practitioners.json
rm Kerry175_Gislason620_fe667044-eea1-3d0f-1b02-156eb1fd8b5c.json
rm Lemuel304_Bogisich202_91dcb4fb-fe99-4235-9193-23001c49352f.json
