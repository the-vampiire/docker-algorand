#!/usr/bin/env bash

set -e

source /home/algorand/.bashrc

start_fast_catchup() {
  local catchpoint="$1"
  
  echo "starting fast catchup to catchpoint: $catchpoint"
  goal node catchup "$catchpoint"
  goal node status

  # sometimes catchup just wont work...
  # https://discord.com/channels/491256308461207573/807825288666939482/943255051592405092
  while [[ -z "$(goal node status | grep Catchpoint | cut -d' ' -f3)" ]]; do
    echo -e '\nfailed to start fast catchup, trying again in 5 seconds...'
    goal node catchup "$catchpoint"
    sleep 5s
  done

  echo -e '\nfast catchup started succesfully'
}

run_catchpoint_if_necessary() {
  local network_catchpoint="$(curl -s https://algorand-catchpoints.s3.us-east-2.amazonaws.com/channel/$ALGORAND_NETWORK/latest.catchpoint)"
  
  local last_block="$(goal node status | head -n 1 | awk '/block: /{print $(NF)}')"
  local catchpoint_block="$(echo $network_catchpoint | cut -d '#' -f 1)"
  
  local block_diff="$(( $catchpoint_block - $last_block ))"
  
  local block_diff_limit=5000

  if (( $block_diff >= $block_diff_limit )); then
    echo "last block [$last_block] is more than [$block_diff_limit] from catchpoint block [$catchpoint_block]"
    start_fast_catchup "$network_catchpoint"
  else
    echo 'node is close to fully synced. skipping fast catchup'
  fi
}

check_status_on_loop() {
  while [ true ]; do
    echo ''
    goal node status
    echo -e '\nChecking status again in 20s'
    sleep 20s
  done
}

startup() {
  run_catchpoint_if_necessary
  check_status_on_loop
}

startup
