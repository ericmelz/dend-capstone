#!/bin.bash

set -ex

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

psql -f $script_dir/create_unnittestdb.sql
