#!/bin/bash

set -ex

echo "Downloading los angeles county zipcode data..."

. variables.sh

rm -f $shapes_dir/*.zip
rm -f $shapes_dir/*.shp
rm -f $shapes_dir/*.prj
rm -f $shapes_dir/*.dbf
rm -f $shapes_dir/*.shx

curl -o $zipcodes_zip_file $zipcodes_shapes_url
unzip $zipcodes_zip_file -d $shapes_dir
