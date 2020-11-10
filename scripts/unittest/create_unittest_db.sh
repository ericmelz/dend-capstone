#!/bin.bash

set -ex

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
script_dir="$( dirname $script_dir )"

psql -f $script_dir/unittest/create_unnittestdb.sql
