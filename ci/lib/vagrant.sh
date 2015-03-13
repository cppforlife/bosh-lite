#!/usr/bin/env bash

set -e -x

# todo needed?
export TERM=xterm

# todo only cleanup when did vagrant up?
trap clean_vagrant EXIT

set_up_vagrant_private_key() {
  if [ ! -f "$BOSH_LITE_PRIVATE_KEY" ]; then
    key_path=$(mktemp -d /tmp/ssh_key.XXXXXXXXXX)/value
    # todo stop using base64 once garden is fixed
    echo "$(echo "$BOSH_LITE_PRIVATE_KEY" | base64 -d 2>/dev/null)" > $key_path
    chmod 600 $key_path
    export BOSH_LITE_PRIVATE_KEY=$key_path
  fi
}

clean_vagrant() {
  ( cd /tmp/build/src/bosh-lite && vagrant destroy -f || true )
}

# todo box_type vs provider
box_add_and_vagrant_up() {
  box_type=$1
  provider=$2
  box_version=$3

  vagrant box add \
    bosh-lite-${box_type}-ubuntu-trusty-${box_version}.box \
    --name bosh-lite-ubuntu-trusty-${box_type}-${box_version} \
    --force

  # vagrant will bring up needed host only networks
  if [ "$box_type" = "virtualbox" ]; then
    VBoxManage hostonlyif remove vboxnet0 || true
    VBoxManage hostonlyif remove vboxnet1 || true
  fi

  vagrant up --provider=$provider
}
