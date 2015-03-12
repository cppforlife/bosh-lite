#!/usr/bin/env bash

set -e -x

source $(dirname $0)/lib/vbox.sh
source $(dirname $0)/lib/box.sh

cd bosh-lite

box_version=$(box_version)

enable_local_vbox

./bin/build-$BOX_TYPE \
	$BOSH_RELEASE_VERSION \
	$WARDEN_RELEASE_VERSION \
	$box_version

upload_box $BOX_TYPE $box_version
