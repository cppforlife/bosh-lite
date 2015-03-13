#!/usr/bin/env bash

set -x -e

source $(dirname $0)/lib/vagrant.sh
source $(dirname $0)/lib/box.sh

cd bosh-lite

box_version=$(box_version)

sed -e "s/BOSH_LITE_CANDIDATE_BUILD_NUMBER/$box_version/" ci/Vagrantfile.aws > Vagrantfile
cat Vagrantfile

set_up_vagrant_private_key

download_box aws $box_version

box_add_and_vagrant_up aws aws $box_version

# todo remove installation
gem install bosh_cli --no-ri --no-rdoc

# Install spiff
wget https://github.com/cloudfoundry-incubator/spiff/releases/download/v1.0.3/spiff_linux_amd64.zip -O /tmp/spiff.zip
unzip /tmp/spiff.zip -d /tmp
sudo mv /tmp/spiff /usr/local/bin/

git clone --depth=1 https://github.com/cloudfoundry/cf-release.git ../cf-release

bin/provision_cf
