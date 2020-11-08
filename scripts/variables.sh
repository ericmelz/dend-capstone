#!/bin/bash

set -ex

base_dir=/home/ubuntu
data_dir=${data_dir:-$base_dir/data}
shapes_dir=$base_dir/shapes
arrests_csv_filename=${arrests_csv_filename:-arrests.csv}
arrests_csv_file=$data_dir/$arrests_csv_filename
zipcodes_zip_file=$shapes_dir/zipcodes.zip
arrests_csv_url='https://data.lacity.org/api/views/yru6-6re4/rows.csv?accessType=DOWNLOAD'
zipcodes_shapes_url='https://data.lacounty.gov/api/geospatial/65v5-jw9f?method=export&format=Shapefile'
database=${database:-postgres}

