#!/bin/false
# shellcheck shell=bash

use macro

function argparse() {
  @args name short long
  cat <<END
	local TEMP
	TEMP=\$(getopt -n "$name" -o "$short" -l "$long" -- "\$@") || error "Can't parse arguments"
	eval set -- \$TEMP
END
}

macroify argparse
