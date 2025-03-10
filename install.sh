#!/bin/bash
# find . -regextype sed -type f -not -regex '\./\.git.*'
toplevel="$(git rev-parse --show-toplevel)"
exec find "$toplevel" -regextype sed -type f -not -regex '.*\.git.*'
