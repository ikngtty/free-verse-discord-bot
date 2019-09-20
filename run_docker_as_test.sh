#!/bin/sh
set -Ceu

color_echo() {
  printf "$(echo $1 |
    sed -e 's/<red>/\\e\[31m/g'     -e 's/<\/red>/\\e\[m/g'     |
    sed -e 's/<green>/\\e\[32m/g'   -e 's/<\/green>/\\e\[m/g'   |
    sed -e 's/<yellow>/\\e\[33m/g'  -e 's/<\/yellow>/\\e\[m/g'  |
    sed -e 's/<blue>/\\e\[34m/g'    -e 's/<\/blue>/\\e\[m/g'    |
    sed -e 's/<purple>/\\e\[35m/g'  -e 's/<\/purple>/\\e\[m/g'  |
    sed -e 's/<magenta>/\\e\[36m/g' -e 's/<\/magenta>/\\e\[m/g' |
    sed -e 's/<white>/\\e\[37m/g'   -e 's/<\/white>/\\e\[m/g'
    )"
  printf "\r\n"
}

if set -o | grep pipefail >/dev/null 2>&1; then
  set -o pipefail
else
  color_echo '<red>WARNING: Cannot use pipefail option.</red>'
fi

log() {
  echo
  color_echo "<magenta>[LOG] $*</magenta>"
}

FREEVERSE_IMAGE=freeverse
FREEVERSE_TEST_CONTAINER=freeverse_test

log 'remove the old container'
docker rm $FREEVERSE_TEST_CONTAINER || true

log 'build a new image (You had better to prune old images later.)'
docker build -t $FREEVERSE_IMAGE .

log 'run a new container'
docker run \
  --name $FREEVERSE_TEST_CONTAINER \
  $FREEVERSE_IMAGE \
  rspec
