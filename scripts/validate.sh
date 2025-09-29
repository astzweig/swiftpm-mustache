#!/bin/bash
SWIFT_FORMAT_VERSION=0.53.10

set -eu
here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function replace_acceptable_years() {
    # this needs to replace all acceptable forms with 'YEARS'
    sed -e 's/20[12][0-9]-20[12][0-9]/YEARS/' -e 's/20[12][0-9]/YEARS/' -e '/^#!/ d'
}

printf "=> Checking format... "
FIRST_OUT="$(git status --porcelain)"
git ls-files -z '*.swift' | xargs -0 swift format format --parallel --in-place
git diff --exit-code '*.swift'

SECOND_OUT="$(git status --porcelain)"
if [[ "$FIRST_OUT" != "$SECOND_OUT" ]]; then
  printf "\033[0;31mformatting issues!\033[0m\n"
  git --no-pager diff
  exit 1
else
  printf "\033[0;32mokay.\033[0m\n"
fi
