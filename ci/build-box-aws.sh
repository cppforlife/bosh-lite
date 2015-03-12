#!/usr/bin/env bash

set -e -x

source $(dirname $0)/lib/box.sh

cd bosh-lite

box_version=$(box_version)

./bin/build-aws \
  $BOSH_RELEASE_VERSION \
  $WARDEN_RELEASE_VERSION \
  $box_version | tee output

ami=`tail -2 output | grep -Po "ami-.*"`

sleep 60

aws ec2 modify-image-attribute \
  --image-id $ami \
  --launch-permission "{\"Add\": [{\"Group\":\"all\"}]}"

upload_box aws $box_version
