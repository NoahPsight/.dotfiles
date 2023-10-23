#!/bin/bash

PROJECTS_FILE="$HOME/.projects"
PROJECTS_HISTORY_FILE="$HOME/.projects_history"

touch "$PROJECTS_FILE"
touch "$PROJECTS_HISTORY_FILE"

source ~/.zshenv

dir_to_str() {
    local str="$1"
    str="${str//\/home\/$USER/\~}"
    str="${str/\/run\/media\/fib\/ExternalSSD\/code/code}"
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

add_project() {
    [[ -z "$1" ]] && echo "$(pwd)" >> "$PROJECTS_FILE" || echo "$1" >> "$PROJECTS_FILE"
}

delete_project() {
    local sel=$(cat "$PROJECTS_FILE" | fzf)
    [[ -n "$sel" ]] && sed -i "/$sel/d" "$PROJECTS_FILE"
}

populate_projects() {
    local projects=()
    local display_projects=()

    while IFS= read -r line; do
        if echo "$line" | grep -q -- '--depth'; then
            local dir=$(echo "$line" | cut -d' ' -f1)
            local depth=$(echo "$line" | cut -d' ' -f3)
            while IFS= read -r sub_dir; do
                projects+=("$sub_dir")
                display_projects+=("$(dir_to_str "$sub_dir")")
            done < <(find -L "$dir" -maxdepth "$depth" -type d)
        else
            projects+=("$line")
            display_projects+=("$(dir_to_str "$line")")
        fi
    done < "$PROJECTS_FILE"
    
    echo "${projects[@]} ${display_projects[@]}"
}

main_execution() {
    local fzf_through=$(cat "$PROJECTS_HISTORY_FILE")
    local projects_display=($(populate_projects))
    local projects=("${projects_display[@]:0:${#projects_display[@]}/2}")
    local display_projects=("${projects_display[@]:${#projects_display[@]}/2}")

    fzf_through=$(printf '%s\n' "$fzf_through" | awk 'NR==FNR{a[$0];next} ($0 in a)' <(printf '%s\n' "${display_projects[@]}") -)
    fzf_through=$(echo "$fzf_through" "${display_projects[@]}")
    fzf_through=$(printf '%s\n' "$fzf_through" | tr ' ' '\n' | awk '!seen[$0]++')

    tmux list-sessions 2>/dev/null | grep -q "attached"
    if [ $? = 0 ]; then
        local current_tmux_session=$(tmux display-message -p '#S')
        current_tmux_session="${current_tmux_session//\"/}"
        fzf_through=$(printf '%s\n' "$fzf_through" | grep -v "^$current_tmux_session$")
    fi
    
    local idx=$(printf '%s\n' "$fzf_through" | fzf +m)
    if [[ -n "$idx" ]]; then
        echo -e "$idx\n$(cat $PROJECTS_HISTORY_FILE)" > "$PROJECTS_HISTORY_FILE"
        head -n 2000 "$PROJECTS_HISTORY_FILE" > "$PROJECTS_HISTORY_FILE.tmp" && mv "$PROJECTS_HISTORY_FILE.tmp" "$PROJECTS_HISTORY_FILE"
        local idx=$(array_search "$idx" "${display_projects[@]}")
        local dir="${projects[$idx]}"
        local tmux_session_name=\"$(dir_to_str "$dir")\"
        
        if ! tmux list-sessions | grep -q "^$tmux_session_name:"; then
            pushd "$dir" > /dev/null
            tmux new-session -d -s "$tmux_session_name"
            popd > /dev/null
        fi
        
        if [[ -n "$TMUX" ]]; then
          tmux switch-client -n -t "$tmux_session_name" 
        else
          tmux attach-session -t "$tmux_session_name"
        fi
    fi
}

main() {
    local cmd="$1"

    case "$cmd" in
        add)
            add_project "${@:2}"
            ;;
        delete)
            delete_project
            ;;
        list)
            local projects=$(populate_projects)
            printf '%s\n' "$projects"
            ;;
        *)
            main_execution
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
