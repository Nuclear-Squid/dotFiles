#! /bin/sh

id=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
if [ "$id" == "0x0" ]; then
    echo 'i3'
    return;
fi
name=$(xprop -id $id | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)
echo "$name"

# https://www.reddit.com/r/Polybar/comments/pwa75n/force_polybar_to_update_script_on_pressing_key/

# sleep_pid=0

# get_window_title() {
#     id=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
#     name=$(xprop -id $id | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)
#     echo "$name"
# }

# trap "get_window_title" USR1

# while true; do
#     sleep 5 &
#     sleep_pid=$!
#     wait
# done
