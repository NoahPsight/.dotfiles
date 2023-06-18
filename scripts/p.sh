#!/usr/bin/env zsh

function p() {
    local cmd="$1"
    declare -A seen
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
            grep -Fvx "$sel" ~/.projects > ~/.projects_temp && mv ~/.projects_temp ~/.projects
            grep -Fvx "$sel" ~/.cache/.project_last > ~/.cache/.project_last_temp && mv ~/.cache/.project_last_temp ~/.cache/.project_last
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
    local recent_projects=()
    if [[ -f ~/.cache/.project_last ]]; then
        while IFS= read -r line; do
            recent_projects+=("$line")
        done < ~/.cache/.project_last
    fi
    local combined_projects=("${recent_projects[@]}" "${projects[@]}")
    local unique_projects=()
    for proj in "${combined_projects[@]}"; do
        if [[ -n "${seen[$proj]}" ]]; then
            continue
        fi
        unique_projects+=("$proj")
        seen["$proj"]=1
    done
    case "$cmd" in
        -l)
            printf '%s\n' "${unique_projects[@]}"
            ;;
        *)
            local dir=$(printf '%s\n' "${unique_projects[@]}" | fzf )
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
                grep -Fvx "$dir" ~/.cache/.project_last > ~/.cache/.project_last_temp && mv ~/.cache/.project_last_temp ~/.cache/.project_last
                echo -e "$dir\n$(cat ~/.cache/.project_last)" > ~/.cache/.project_last
            fi
            ;;
    esac
}

p "$@"
