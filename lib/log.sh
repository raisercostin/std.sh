#!/bin/false
# shellcheck shell=bash

_stdsh_LOG_LEVEL=4

get_log_level() {
  @args level
  declare -r -A LOG_LEVELS=(
    ["alert"]="0"
    ["crit"]="1" ["critical"]="1"
    ["err"]="2" ["error"]="2"
    ["warn"]="3" ["warning"]="3"
    ["note"]="4" ["notice"]="4" ["notify"]="4"
    ["info"]="5"
    ["debug"]="6"
  )
  if [[ " ${!LOG_LEVELS[*]} " == *" $level "* ]]; then
    echo "${LOG_LEVELS[$level]}"
  elif [[ " ${LOG_LEVELS[*]} " == *" $level "* ]]; then
    echo "$level"
  else
    echo "std.sh: strange log level was requested: $level" 1>&2
    echo $_stdsh_LOG_LEVEL
  fi
}

log_level() {
  @args level
  local l=$(get_log_level $level)
  if [ "$l" -gt 6 ]; then
    _stdsh_LOG_LEVEL=6
  elif [ "$l" -lt 0 ]; then
    _stdsh_LOG_LEVEL=0
  else
    _stdsh_LOG_LEVEL="$l"
  fi
}

# This function declares the format of logs.
# It can be redefined by user for whatever purpose.
log_format() {
  @args level msg...
  echo -n "${msg[@]}"
}

log() {
  @args level msg...
  [[ $(get_log_level $level) > $_stdsh_LOG_LEVEL ]] && return

  log_format "${argv[@]}" | fmt -t 1>&2
}
