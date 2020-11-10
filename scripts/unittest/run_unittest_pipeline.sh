#!/bin/bash

# Unit test of pipeline
# First loads 9 rows from .csv, and tests the rows wind up in the fact table
# Then loads an .csv with the original 9 rows plus 10 new rows.
# Ensure that 19 rows are in the fact table.
# Quality checks are also done by the ./run_pipeline.sh script

set -ex

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
script_dir="$( dirname $script_dir )"

. $script_dir/variables.sh

$script_dir/setup_unittest.sh

# add 9 rows
env database=unittest data_dir=$project_dir/unittest_data shapes_dir=$project_dir/unittest_shapes arrests_csv_filename=arrests_head10.csv $script_dir/pipeline/run_pipeline.sh

# check that there are 9 rows
. $python_dir/.env/bin/activate
python3 $script_dir/quality_checks/check_fact_rows.py 9

# add 10 more rows
env database=unittest data_dir=$project_dir/unittest_data shapes_dir=$project_dir/unittest_shapes arrests_csv_filename=arrests_head20.csv $script_dir/pipeline/run_pipeline.sh
python3 $script_dir/quality_checks/check_fact_rows.py 19
