#!/bin/bash

set -ex

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
script_dir="$( dirname $script_dir )"

. $script_dir/variables.sh

echo "Loading zipcode shapes..."

psql -f $script_dir/pipeline/init_zipcodes.sql -d $database
shp2pgsql $shapes_dir/*.shp zip_codes | psql -d $database
psql -f $script_dir//pipeline/create_zipcode_index.sql -d $database
