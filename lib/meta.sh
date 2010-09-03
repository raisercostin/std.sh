#!/bin/false

func-print ()
{
    eval `@args func_name`
    declare -f "$func_name"
}

func-print-body ()
{
    eval `@args func_name`
    print-func "$func_name" | tail -n +3 | head -n -1
}

func-copy ()
{
    eval `@args old_name new_name`
    eval "
function $new_name
{
    $(print-func-body "$old_name")
}"
}

is-interactive ()
{
    eval `@args`
    case "$_" in
        *i*) return 0 ;;
          *) return 1 ;;
     esac
}
