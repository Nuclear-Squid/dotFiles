#! /bin/sh

# First 3 lines are not to be messed with.
i3status --transparency | (read line; echo $line; read line; echo $line; read line; echo $line; while :
do
    read line

    # Show the name of the currently focused window.
    id=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
    name=$(xprop -id $id | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)
    rendered_name="{\"name\":\"title\",\"markup\":\"none\",\"full_text\":\"$name\",\"align\":\"center\",\"min_width\":900}"
    # huge min_width is a disgusting hack to try and have a centered module.

    line=$(echo $line | cut -d '[' -f 2)
    echo ",[$rendered_name, $line" || exit 1
done)
