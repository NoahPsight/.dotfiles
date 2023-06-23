#!/bin/zsh

i=1
print_list() {
    echo "$i"
    while IFS= read -r project; do
        echo "$project"
    done <<< "$1"
    echo ""
    i=$((i+1))
}

warper() {
    projects_file=~/.projects
    cache_file=~/.recent
    projects=$(cat "$projects_file")
    recent=$(cat "$cache_file")

    projects=$(grep -vFf <(echo "$recent") <(echo "$projects"))
    projects=$(printf "%s\n%s" "$recent" "$projects")


    grep -vFx "$sel" $cache_file > /tmp/temp && mv /tmp/temp $cache_file
    sed -i "1i $sel" "$cache_file"
}

warper
