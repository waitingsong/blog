#!/bin/bash
set +e

find $cwd -type f -iname "*.mjs" -print0 | xargs -0II git update-index --ignore-missing --chmod=+x I
find $cwd -type f -iname "*.sh" -print0 | xargs -0II git update-index --ignore-missing --chmod=+x I
find $cwd -type f -iname "*.ts" -print0 | xargs -0II git update-index --ignore-missing --chmod=+x I

set -e

