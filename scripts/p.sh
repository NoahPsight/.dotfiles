#!/usr/bin/env zsh

function p() {
    local cmd="$1"
    local projects=()
    if [[ "$cmd" == "-a" ]]; then
        if [[ -z "$2" ]]; then
            echo "$(pwd)" >> ~/.projects
        else
            echo "${@:2}" >> ~/.projects
        fi
        return 0
    fi
    if [[ "$cmd" == "-d" ]]; then
        sel=$(cat ~/.projects | fzf)
        if [[ -n "$sel" ]]; then
            sed -i "/$sel/d" ~/.projects
        fi
        return 0
    fi
    while IFS= read -r line; do
        if echo "$line" | grep -q -- '--depth'; then
            local dir=$(echo "$line" | cut -d' ' -f1)
            local depth=$(echo "$line" | cut -d' ' -f3)
            while IFS= read -r sub_dir; do
                projects+=("$sub_dir")
            done < <(find -L "$dir" -maxdepth "$depth" -type d)
        else
            projects+=("$line")
        fi
    done < ~/.projects
    case "$cmd" in
        -l)
            printf '%s\n' "${projects[@]}"
            ;;
        *)
            local dir=$(printf '%s\n' "${projects[@]}" | fzf +m)
            if [[ -n "$dir" ]]; then
                local tmux_session_name=$(echo "$dir" | tr '.' '_')
                if ! tmux list-sessions | grep -q "^$tmux_session_name:"; then
                    pushd "$dir" > /dev/null
                    tmux new-session -d -s "$tmux_session_name"
                    popd > /dev/null
                fi
                if [[ -n "$TMUX" ]]; then
                    tmux switch-client -t "$tmux_session_name"
                else
                    tmux attach-session -t "$tmux_session_name"
                fi
            fi
            ;;
    esac
}

p "$@"
