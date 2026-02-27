_android_home() {
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    local commands="setup start status services update completion help"
    local services="filebrowser cloudflare-tunnel"

    case "$prev" in
        setup)  COMPREPLY=($(compgen -W "$services all" -- "$cur")) ;;
        start)  COMPREPLY=($(compgen -W "$services" -- "$cur")) ;;
        *)      COMPREPLY=($(compgen -W "$commands" -- "$cur")) ;;
    esac
}

complete -F _android_home android-home
