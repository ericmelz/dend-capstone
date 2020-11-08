#!/bin/bash

set -ex

psql -f setup_unittest.sql -d unittest
