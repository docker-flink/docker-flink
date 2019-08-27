#!/bin/bash -ex

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

. "${SCRIPT_DIR}/testing_lib.sh"

IS_PULL_REQUEST=
if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  IS_PULL_REQUEST=1
fi

BRANCH="$TRAVIS_BRANCH"

if [ -n "$IS_PULL_REQUEST" ]; then
  changed_files="$(git diff --name-only $TRAVIS_BRANCH...HEAD)"
  if echo "${changed_files}" | grep -q -e '^\d\+\.\d\+/'; then
    echo >&2 'Generated files in x.y/ directories should not be modified.'
    exit 1
  fi
fi

exit 0

if [ -z "$IS_PULL_REQUEST" ] && [ "$BRANCH" = "master" ]; then
  # Test all images on master
  smoke_test_all_images
  smoke_test_non_root
else
  # For pull requests and branches, test one image
  smoke_test_one_image
fi

# vim: et ts=2 sw=2
