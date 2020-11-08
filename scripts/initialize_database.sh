#!/bin/bash

set -ex

. ./variables.sh

psql -f initialize_database.sql -d $database
