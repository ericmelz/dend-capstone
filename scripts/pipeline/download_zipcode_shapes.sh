#!/bin/bash

set -ex

echo "Downloading los angeles county zipcode data..."

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
script_dir="$( dirname $script_dir )"

. $script_dir/variables.sh
echo "script_dir is $script_dir"
echo "project__dir is $project_dir"

rm -f $shapes_dir/*.zip
rm -f $shapes_dir/*.shp
rm -f $shapes_dir/*.prj
rm -f $shapes_dir/*.dbf
rm -f $shapes_dir/*.shx

curl -o $zipcodes_zip_file $zipcodes_shapes_url
unzip $zipcodes_zip_file -d $shapes_dir
