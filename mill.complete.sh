# bash completion for mill

_mill()
{
    # variables
    local cur prev split=false
    local mill_out dot_count mill_resolve

    COMPREPLY=()
    _get_comp_words_by_ref -n : cur prev

    _split_longopt && split=true

    case $prev in
        -h|--home|-p|--predef)
            _filedir
            return 0
            ;;
    esac

    $split && return 0

    if [[ "$cur" == -* ]]; then
        COMPREPLY=( $( compgen -W '-c -h -p -s -w -i\
          --code --color\
          --disable-ticker\
          --help --home\
          --interactive\
          --no-default-predef\
          --predef\
          --silent
          --watch' -- "$cur" ) )
    else

        if [[ "$cur" =~ .*[.].* ]]; then

            # already specified a dot, so complete all
            mill_out="$( mill --disable-ticker resolve __._ 2> /dev/null )"
            COMPREPLY=( $( compgen -W "${mill_out}" -- "$cur" ) )

        else

            # nothing specified yet
            mill_out="$( mill --disable-ticker resolve _ _._ 2> /dev/null )"
            COMPREPLY=( $( compgen -W "${mill_out}" -- "$cur" ) )

        fi

    fi

    __ltrim_colon_completions "${cur}"

} &&
complete -F _mill mill
