#!/bin/bash

set -ex

. variables.sh

echo "Loading zipcode shapes..."

psql -f init_zipcodes.sql -d $database
shp2pgsql $shapes_dir/*.shp zip_codes | psql -d $database
psql -f create_zipcode_index.sql -d $database
