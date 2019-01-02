#!/bin/false

_stdsh_LOG_LEVEL=4

get_log_level() {
	@args level
	declare -r -A LOG_LEVELS=(
		["alert"]="0"
		["crit"]="1"
		["err"]="2"
		["warn"]="3"
		["note"]="4"
		["info"]="5"
		["debug"]="6"
	)
	if [[ " ${!LOG_LEVELS[*]} " == *" $level "* ]] ; then
		echo "${LOG_LEVELS[$level]}"
	elif [[ " ${LOG_LEVELS[*]} " == *" $level "* ]] ; then
		echo "$level"
	else
		echo "std.sh: strange log level was requested" 1>&2
		echo $_stdsh_LOG_LEVEL
	fi
}

log_level() {
	@args level
	_stdsh_LOG_LEVEL="$(get_log_level $level)"
}

# This function declares the format of logs.
# It can be redefined by user for whatever purpose.
log_format() {
	@args level msg...
	echo -n  "${msg[@]}" 
}

log ()
{
    @args level msg...
    [[ $(get_log_level $level) > $_stdsh_LOG_LEVEL ]] && return

    log_format "${argv[@]}" | fmt -t 1>&2
}
