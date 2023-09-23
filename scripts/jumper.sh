#!/bin/bash

PROJECTS_FILE="$HOME/.projects"
PROJECTS_HISTORY_FILE="$HOME/.projects_history"

touch "$PROJECTS_FILE"
touch "$PROJECTS_HISTORY_FILE"

source ~/.zshenv

dir_to_str() {
    local str="$1"
    str="${str//\/home\/$USER/\~}"
    str="${str//./}"
    echo "$str"
}

array_search() {
    local target="$1"
    shift
    local arr=("$@")
    for i in "${!arr[@]}"; do
        if [[ "${arr[$i]}" == "$target" ]]; then
            echo "$i"
            return
        fi
    done
    echo -1
}

p() {
    local cmd="$1"
    local projects=()
    local display_projects=()

    if [[ "$cmd" == "-a" ]]; then
        [[ -z "$2" ]] && echo "$(pwd)" >> "$PROJECTS_FILE" || echo "${@:2}" >> "$PROJECTS_FILE"
        return 0
    fi

    if [[ "$cmd" == "-d" ]]; then
        sel=$(cat "$PROJECTS_FILE" | fzf)
        [[ -n "$sel" ]] && sed -i "/$sel/d" "$PROJECTS_FILE"
        return 0
    fi

    while IFS= read -r line; do
        if echo "$line" | grep -q -- '--depth'; then
            dir=$(echo "$line" | cut -d' ' -f1)
            depth=$(echo "$line" | cut -d' ' -f3)
            while IFS= read -r sub_dir; do
                projects+=("$sub_dir")
                display_projects+=("$(dir_to_str "$sub_dir")")
            done < <(find -L "$dir" -maxdepth "$depth" -type d)
        else
            projects+=("$line")
            display_projects+=("$(dir_to_str "$line")")
        fi
    done < "$PROJECTS_FILE"
    
    case "$cmd" in
        -l)
            printf '%s\n' "${projects[@]}"
            ;;
        *)
            fzf_through=$(cat "$PROJECTS_HISTORY_FILE")
            fzf_through=$(printf '%s\n' "$fzf_through" | awk 'NR==FNR{a[$0];next} ($0 in a)' <(printf '%s\n' "${display_projects[@]}") -)
            fzf_through=$(echo "$fzf_through" "${display_projects[@]}")
            fzf_through=$(printf '%s\n' "$fzf_through" | tr ' ' '\n' | awk '!seen[$0]++')
            
            tmux list-sessions 2>/dev/null | grep -q "attached"
            if [ $? = 0 ]; then
                current_tmux_session=$(tmux display-message -p '#S')
                current_tmux_session="${current_tmux_session//\"/}"
                fzf_through=$(printf '%s\n' "$fzf_through" | grep -v "^$current_tmux_session$")
            fi
            
            idx=$(printf '%s\n' "$fzf_through" | fzf +m)
            if [[ -n "$idx" ]]; then
                echo -e "$idx\n$(cat $PROJECTS_HISTORY_FILE)" > "$PROJECTS_HISTORY_FILE"
                head -n 2000 "$PROJECTS_HISTORY_FILE" > "$PROJECTS_HISTORY_FILE.tmp" && mv "$PROJECTS_HISTORY_FILE.tmp" "$PROJECTS_HISTORY_FILE"
                idx=$(array_search "$idx" "${display_projects[@]}")
                dir="${projects[$idx]}"
                tmux_session_name=\"$(dir_to_str "$dir")\"
                
                if ! tmux list-sessions | grep -q "^$tmux_session_name:"; then
                    pushd "$dir" > /dev/null
                    tmux new-session -d -s "$tmux_session_name"
                    popd > /dev/null
                fi
                
                [[ -n "$TMUX" ]] && tmux switch-client -n -t "$tmux_session_name" || tmux attach-session -t "$tmux_session_name"
            fi
            ;;
    esac
}

p "$@"
