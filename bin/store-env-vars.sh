#!/bin/bash

OUT_FILE="environment.out"

if [ ! -d bin ]; then
  echo -e "Error: run bin/${0} from the repo root"
  exit 1
fi

echo 'PATH=$(pwd)/bin:${PATH}' > $OUT_FILE
terraform output | sed 's/ //g' | awk '{print "export " $0}' >> $OUT_FILE

