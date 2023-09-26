#!/bin/bash -x

REQUEST="{\"contentStructure\":\"BUNDLE_PRETTY\",\"gcsSource\":{\"uri\":\"gs://${gcs_bucket}/in/*\"}}"
RESPONSE=$(curl -X POST -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" -H "Content-Type: application/json; charset=utf-8" --data $REQUEST ${fhir_url}:import)

echo ${RESPONSE}
