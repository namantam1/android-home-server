_android_home() {
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    local commands="setup run start stop status services update completion help"
    local services="filebrowser cloudflare-tunnel"

    case "$prev" in
        setup|run|start|stop) COMPREPLY=($(compgen -W "$services" -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$commands" -- "$cur")) ;;
    esac
}

complete -F _android_home android-home
