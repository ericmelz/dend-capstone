#!/bin/bash

set -ex

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. $script_dir/variables.sh

echo "Loading zipcode shapes..."

psql -f $script_dir/init_zipcodes.sql -d $database
shp2pgsql $shapes_dir/*.shp zip_codes | psql -d $database
psql -f $script_dir/create_zipcode_index.sql -d $database
