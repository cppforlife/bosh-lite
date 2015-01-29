#!/usr/bin/env bash

set -xe

source $(dirname $0)/test_helpers.sh

trap cleanup EXIT

main() {
  clean_vagrant
  setup_directories
  set_vagrant_home
  setup_private_routing
  wget -N https://s3.amazonaws.com/bosh-lite-ci-pipeline/bosh-lite-${BOX_TYPE}-ubuntu-trusty-${BOSH_LITE_CANDIDATE_BUILD_NUMBER}.box
  box_add_and_vagrant_up $BOX_TYPE $PROVIDER $BOSH_LITE_CANDIDATE_BUILD_NUMBER

  bin/provision_cf
}

setup_private_routing() {
  sed -e "s/BOSH_LITE_CANDIDATE_BUILD_NUMBER/$BOSH_LITE_CANDIDATE_BUILD_NUMBER/" ci/Vagrantfile.virtualbox > Vagrantfile
  sed -i'' -e "s/PRIVATE_NETWORK_IP/192.168.50.4/" Vagrantfile
  cat Vagrantfile
  sed -i'' -e "s/192.168.50.4/$PRIVATE_NETWORK_IP/" bin/add-route
  cat bin/add-route

  set +e
  bin/add-route
  set -e
}

setup_directories() {
  if [ ! -d '../cf-release' ]; then
    git clone --depth=1 https://github.com/cloudfoundry/cf-release.git ../cf-release
  fi

  ln -sf $PWD ../bosh-lite
}

set_vagrant_home() {
  export VAGRANT_HOME=/var/vcap/data/.vagrant.d
}

main
