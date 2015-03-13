#!/usr/bin/env bash

set -e -x

source $(dirname $0)/lib/vagrant.sh
source $(dirname $0)/lib/vbox.sh
source $(dirname $0)/lib/bats.sh
source $(dirname $0)/lib/box.sh

cd bosh-lite

enable_local_vbox

box_version=$(box_version)
private_net_ip=${PRIVATE_NETWORK_IP:-192.168.50.4}

sed -e "s/BOSH_LITE_CANDIDATE_BUILD_NUMBER/$box_version/" ci/Vagrantfile.$BOX_TYPE > Vagrantfile

sed -i'' -e "s/PRIVATE_NETWORK_IP/$private_net_ip/" Vagrantfile
cat Vagrantfile

sed -i'' -e "s/192.168.50.4/$private_net_ip/" bin/add-route
cat bin/add-route

download_box $BOX_TYPE $box_version

box_add_and_vagrant_up $BOX_TYPE $PROVIDER $box_version

./bin/add-route || true

run_bats $private_net_ip ubuntu-trusty
