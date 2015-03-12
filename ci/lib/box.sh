#!/bin/bash

box_version() {
  echo ${BOSH_LITE_CANDIDATE_BUILD_NUMBER:-`cat /tmp/builds/src/box-version/number`}
}

download_box() {
  box_type=$1
  box_version=$2

  box_name=bosh-lite-${box_type}-ubuntu-trusty-${box_version}.box
  rm -f $box_name
  wget "https://s3.amazonaws.com/test-bosh-lite-bucket/${box_name}"
}

upload_box() {
  box_type=$1
  box_version=$2

  box_name=bosh-lite-${box_type}-ubuntu-trusty-${box_version}.box
  s3cmd \
    --access_key=$BOSH_AWS_ACCESS_KEY_ID \
    --secret_key=$BOSH_AWS_SECRET_ACCESS_KEY \
    put $box_name s3://test-bosh-lite-bucket/
}
