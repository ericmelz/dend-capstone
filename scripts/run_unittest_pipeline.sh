#!/bin/bash

set -ex

base_dir=/home/ubuntu

./setup_unittest.sh
env database=unittest data_dir=$base_dir/unittest_data shapes_dir=$base_dir/unittest_shapes arrests_csv_filename=arrests_head10.csv ./run_pipeline.sh
