#!/usr/bin/env bash

set -e -x

source $(dirname $0)/lib/vagrant.sh
source $(dirname $0)/lib/bats.sh
source $(dirname $0)/lib/box.sh

cd bosh-lite

box_version=$(box_version)

sed -e "s/BOSH_LITE_CANDIDATE_BUILD_NUMBER/$box_version/" ci/Vagrantfile.aws > Vagrantfile
cat Vagrantfile

set_up_vagrant_private_key

download_box aws $box_version

box_add_and_vagrant_up aws aws $box_version

run_bats_on_vm ubuntu-trusty
