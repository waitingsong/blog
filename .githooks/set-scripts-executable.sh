#!/bin/bash
set +e

find . -type f -iname "*.sh" -print0 | xargs -0II git update-index --ignore-missing --chmod=+x I
find . -type f -iname "*.mjs" -print0 | xargs -0II git update-index --ignore-missing --chmod=+x I

set -e

