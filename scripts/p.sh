#!/usr/bin/env zsh

source ~/.zshenv

function dir_to_str {
    local str=$1
    str=${str//\/home\/$USER/\~}
    str=${str//\/mnt\/externalssd\/code/code}
    str=${str//./}
    echo "$str"
}


function array_search() {
  local target=$1
  shift
  local arr=("${@}")
  for i in "${!arr[@]}"; do
    if [[ "${arr[$i]}" == "$target" ]]; then
      echo $i
      return
    fi
  done
  echo -1
}

function p() {
    local cmd="$1"
    local projects=()
    local display_projects=()
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
                display_projects+=( "$(dir_to_str "$sub_dir")" )
            done < <(find -L "$dir" -maxdepth "$depth" -type d)
        else
            projects+=("$line")
            display_projects+=( "$(dir_to_str "$line")" )
        fi
    done < ~/.projects
    case "$cmd" in
        -l)
            printf '%s\n' "${projects[@]}"
            ;;
        *)
            local fzf_through=$(cat ~/.projects_history)
            fzf_through=$(printf '%s\n' "$fzf_through" | awk 'NR==FNR{a[$0];next} ($0 in a)' <(printf '%s\n' "${display_projects[@]}") -)
            fzf_through=$( \
                echo "$fzf_through" \
                "${display_projects[@]}" \
            )
            fzf_through=$(printf '%s\n' "$fzf_through" | tr ' ' '\n' | awk '!seen[$0]++')
            local current_tmux_session=$(tmux display-message -p '#S')
            current_tmux_session="${current_tmux_session//\"/}"
            fzf_through=$(printf '%s\n' "$fzf_through" | grep -v "^$current_tmux_session$")
            local idx=$(printf '%s\n' $fzf_through | fzf +m)
            if [[ -n "$idx" ]]; then
                echo -e "$idx\n$(cat ~/.projects_history)" > ~/.projects_history
                head -n 2000 ~/.projects_history > ~/.projects_history.tmp && mv ~/.projects_history.tmp ~/.projects_history
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
            ;;
    esac
}

p "$@"
