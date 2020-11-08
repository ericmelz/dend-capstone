#!/bin/bash

set -ex

. variables.sh

if [ $database != 'unittest' ]; then
  ./download_arrests.sh
  ./download_zipcode_shapes.sh
fi
./load_zipcode_shapes.sh

echo "Running pipeline..."
psql -v arrest_csv_file=$arrests_csv_file -f pipeline.sql -d $database
