_android_home() {
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    local commands="setup run start stop restart enable disable logs status services ip info doctor backup restore completion update help"
    local services="filebrowser cloudflare-tunnel"

    case "$prev" in
        setup|run|start|stop|restart|enable|disable|logs)
            COMPREPLY=($(compgen -W "$services" -- "$cur")) ;;
        restore)
            COMPREPLY=($(compgen -f -- "$cur")) ;;
        *)
            COMPREPLY=($(compgen -W "$commands" -- "$cur")) ;;
    esac
}

complete -F _android_home android-home
