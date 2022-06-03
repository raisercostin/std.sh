#!/bin/false
# shellcheck shell=bash

module() {
  @args library
}

use-single() {
  @args library
  if [ "${#STDSH_LIBRARIES[@]}" -eq 0 ]; then
    declare -A STDSH_LIBRARIES
  fi
  if [ -z "${STDSH_LIBRARIES["$library"]}" ]; then
    local lib_path="$STDSH_PATH/lib/${library}.sh"
    STDSH_LIBRARIES["$library"]="$lib_path"
    if ! source "$lib_path"; then
      unset STDSH_LIBRARIES["$library"]
      error "Couldn't load library $lib_path"
    fi
  fi
}

use() {
  @args libs...
  for lib in "${libs[@]}"; do
    use-single "$lib"
  done
}
