#!/bin/bash

set -ex

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. $script_dir/variables.sh

echo "Downloading Los Angeles arrest data..."

rm -f $arrests_csv_file

echo "execing: curl -o $arrests_csv_file $arrests_csv_url"
curl -o $arrests_csv_file $arrests_csv_url
