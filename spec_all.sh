#!/bin/bash

cd "$(dirname "$0")"
cd ..

echo "Running spec on all projects..."
find . -maxdepth 1  -type d -iname "ricer4*" -exec sh -c 'echo && echo "$1" && echo && cd $1 && bundle update 1>/dev/null && bundle exec rake 1>/dev/null' _ {} \;
