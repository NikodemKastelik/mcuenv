#!/bin/bash

function abs_path_get {
    echo "$( cd "$1" ; pwd -P )"
}

invoked_script_path="$(abs_path_get "$(dirname $0)")"
dir_to_mock_path="$(abs_path_get $1)"

cmock_script=${invoked_script_path}/cmock/lib/cmock.rb
cmock_config=${invoked_script_path}/cmock_config.yml

find $dir_to_mock_path/*.h -maxdepth 1 -type f | \
    xargs ruby ${cmock_script} -o${cmock_config}

