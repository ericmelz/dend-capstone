#!/bin/bash

set -ex

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
script_dir="$( dirname $script_dir )"

. .$script_dir/variables.sh

psql -f $script_dir/initialize_database.sql -d $database
