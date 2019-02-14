# @macro [ expr ... ] == eval "$(expr)"
use args

# The var-substitute solution (without additional variable).
# This approach is fail-prone if macro has pattern ' \#' in it.
# Pro: simple; Con: macro-command doesn't work
#alias       @macro=$'eval "${BASH_COMMAND/*\\\#/eval \\\"\$( } )\\\" " \#'
#alias @macro-print=$'eval "${BASH_COMMAND/*\\\#/echo \\\"\$( } )\\\" " \#'

# Copy-paste solution
# It stores full command in variable
# Pro: macro-command works again; Con: DRY voliation
#alias       @macro=$'_stdsh_MACRO_COMMAND="\'${BASH_COMMAND#* \\\# }\'" eval "eval \\"\$(${BASH_COMMAND#* \\\# })\\"" \#'
#alias @macro-print=$'_stdsh_MACRO_COMMAND="\'${BASH_COMMAND#* \\\# }\'" eval "echo \\"\$(${BASH_COMMAND#* \\\# })\\"" \#'

# Dummy-variable solution
# Variable exists, but doesn't contain command
# Pros: macro-command works, still simple enough
# Con: none known yet.
alias       @macro=$'_stdsh_MACRO_COMMAND="yes" eval "eval \\"\$(${BASH_COMMAND#* \\\# })\\"" \#'
alias @macro-print=$'_stdsh_MACRO_COMMAND="yes" eval "echo \\"\$(${BASH_COMMAND#* \\\# })\\"" \#'

macro-command ()
{
   @args
   if [ -n "$_stdsh_MACRO_FUNCTION" ]
   then
       echo "${_stdsh_MACRO_COMMAND:$[ ${#_stdsh_MACRO_FUNCTION} +1 ]}"
   else
       echo "$_stdsh_MACRO_COMMAND"
   fi
}

macroify()
{
    @args funcname
    funcname="$(printf '%q' "$funcname")"
    alias "@$funcname=_stdsh_MACRO_FUNCTION=$funcname @macro $funcname"
}

macro? ()
{
    @args
    [[ -n "$_stdsh_MACRO_COMMAND" ]]
}
