#!/bin/bash
# This script checks that files required for the application to meaningfully
# run are present, and reports failure if they are not.
echo ; echo "Checking required files for the api application are present."

if [[ -e "./config/database.yml" ]]; then
  echo "./config/database.yml exists"
else
  error1=1
fi

if [[ -e "./.env" ]]; then
  echo "./.env exists"
else
  error2=1
fi


