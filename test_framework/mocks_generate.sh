#!/bin/bash

function mock_given_directory {
    local dir=$1
    find $dir -maxdepth 1 -type f | xargs ruby cmock/lib/cmock.rb -ocmock_config.yml
}

cd "$(dirname "$0")"
mock_given_directory $1

