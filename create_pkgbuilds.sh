#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<EOF
usage: $0 targets_list work_dir
EOF
}

if [[ $# != 2 ]]; then
  usage >&1
  exit 255
fi

readonly TARGET="$1"
readonly WORK_DIR="$2"

while read -r package version source
do
  echo Preparing "$package"

  # compute hash
  hash="$(curl -Ls "$source" | sha512sum - | awk '{print $1}')"
  
  # substitutions
  sed                              \
    -e "s|PKGDESC|TODO|"           \
    -e "s|CUDA_VERSION|10.2|"      \
    -e "s|PKGNAME|$package|"       \
    -e "s|PKGSHA|$hash|"           \
    -e "s|PKGURL|$source|"         \
    -e "s|PKGVER|${version//-/.}|" \
    "$WORK_DIR/$package"/PKGBUILD.in > "$WORK_DIR/$package"/PKGBUILD
done < "$TARGET"

# vim:set ts=8 sts=2 sw=2 et:
