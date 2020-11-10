#!/bin/bash

set -ex

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
script_dir="$( dirname $script_dir )"

. $script_dir/variables.sh

if [ $database != 'unittest' ]; then
  $script_dir/pipeline/download_arrests.sh
  $script_dir/pipeline/download_zipcode_shapes.sh
fi

$script_dir/pipeline/load_zipcode_shapes.sh

echo "Running pipeline..."
psql -v arrest_csv_file=$arrests_csv_file -f $script_dir/pipeline/pipeline.sql -d $database

if [ $database != 'unittest' ]; then
    $script_dir/quality_checks/run_production_quality_checks.sh
else
    $python_dir/quality_checks/run_unittest_quality_checks.sh
fi
