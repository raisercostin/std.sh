#!/usr/bin/env bash

eval $(std.sh)

use log

echo "-- Test variables"
declare -A LOG_LEVELS=(["alert"]="0" ["crit"]="1" ["err"]="2" ["warn"]="3" ["note"]="4" ["info"]="5" ["debug"]="6")
echo "Default log level (4): $_stdsh_LOG_LEVEL"
echo "Content of LOG_LEVELS[*]:" "${!LOG_LEVELS[*]} ; ${LOG_LEVELS[*]}"

echo "-- Test simple message"
log alert "Alert message"

function test_all_messages() {
  for i in "${!LOG_LEVELS[@]}"; do
    log_level "$i"
    echo "-- Set log level to '$i'"

    for j in "${!LOG_LEVELS[@]}"; do
      log "$j" "Message with level $j "
    done
  done
}

echo "-- Test setting leg level to 'foo_bar'"
log_level foo_bar
log_level note

echo "-- Test default output"
test_all_messages

echo "-- Test fancy log_format redefinition"
unset log_format
log_format() {
  @args level msg...
  echo "[$(basename ${0^^})]" [${level^^}] "${msg[@]}"
}

test_all_messages
