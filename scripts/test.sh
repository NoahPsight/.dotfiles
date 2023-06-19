#!/bin/bash

f1=~/.projects
f2=~/.cache/.recent_projects

function diff_arrays() {
  local a=("${!1}")
  local b=("${!2}")
  local c=()
  for i in "${a[@]}"; do
    found=false
    for j in "${b[@]}"; do
      if [ "$i" = "$j" ]; then
        found=true
        break
      fi
    done
    if [ "$found" = "false" ]; then
      c+=($i)
    fi
  done
  echo "${c[@]}"
}

function combine_arrays() {
  local a=("${!1}")
  local b=("${!2}")
  local c=("${a[@]}" "${b[@]}")
  echo "${c[@]}"
}

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
    done < $f1
    local recents=()
    if [[ -f $f2 ]]; then
        while IFS= read -r line; do
            recents+=("$line")
        done < $f2
        projects=($(diff_arrays projects[@] recents[@]))
        projects=($(combine_arrays recents[@] projects[@]))
    fi
    case "$cmd" in
        -l)
            printf '%s\n' "${projects[@]}"
            ;;
        *)
            local dir=$(printf '%s\n' "${projects[@]}" | fzf )
            if [[ -z "$dir" ]]; then
                return 0
            fi
            local tmux_session_name=$(echo "$dir" | tr '.' '_')
            if ! tmux list-sessions | grep -q "^$tmux_session_name:"; then
                pushd "$dir" > /dev/null
                tmux new-session -d -s "$tmux_session_name"
                popd > /dev/null
            fi

            if [[ -f $f2 ]]; then
                out=( "$dir" )
                for i in "${recents[@]}"; do
                    if [[ "$i" != "$dir" ]]; then
                        echo "$i"
                        echo "$dir"
                        out+=("$i")
                    fi
                done
                echo -n "" > $f2
                for val in "${out[@]}"; do
                    echo "$val" >> $f2
                done
            else
                echo "$dir" > $f2
            fi



            if [[ -n "$TMUX" ]]; then
                tmux switch-client -t "$tmux_session_name"
            else
                tmux attach-session -t "$tmux_session_name"
            fi
            ;;
    esac
}

p "$@"
