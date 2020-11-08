#!/bin/bash

set -ex

. variables.sh

echo "Downloading Los Angeles arrest data..."

rm -f $arrests_csv_file

echo "execing: curl -o $arrests_csv_file $arrests_csv_url"
curl -o $arrests_csv_file $arrests_csv_url
