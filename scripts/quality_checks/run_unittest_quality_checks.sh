#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. $script_dir/.env/bin/activate
python3 $script_dir/quality_checks.py unittest
