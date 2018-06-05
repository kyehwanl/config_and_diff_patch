#!/bin/sh
# source : 
# https://blog.nelhage.com/2010/05/using-x-forwarding-with-screen/
# https://github.com/nelhage/x11-proxy/blob/master/proxy-display

usage () {
    echo "Usage: $0 DISPLAY" >&2
    exit 1
}

target="$1"

[ "$target" ] || usage

xauth_display() {
    echo "$1" | perl -lne 'print $1 if m{(:\d+)}'
}

display_num() {
    dpy="$1"
    num=${dpy#*:}
    num=${num%.*}
    echo "$num"
}

find_listen_inodes() {
    dpy="$1"
    num=$(display_num "$dpy")
    case "$dpy" in
        :*)
            grep -F "/tmp/.X11-unix/X$num" /proc/net/unix | \
                perl -lane 'print $F[6] if hex($F[3]) & 0x10000'
            ;;
        localhost:*)
            env num=$num \
                perl -lane 'print $F[9] if $F[1] eq (sprintf"0100007F:%X", 6000+$ENV{num})' \
                /proc/net/tcp
            ;;
    esac
}

kill_listeners() {
    inodes=$(find_listen_inodes "$1")
    pids=""
    for i in $inodes; do
        new=$(find /proc/ -maxdepth 4 -wholename '*/fd/*' -lname "socket:\\[$i\\]" 2>/dev/null | \
            perl -F/ -lane 'print $F[2]')
        pids="$pids $new"
    done
    kill $pids 2>/dev/null
}

xauth=$(xauth list "$(xauth_display "$DISPLAY")")

if [ "$xauth" ]; then
    xauth add "$(xauth_display "$target")" $(echo "$xauth" | cut -f2- -d ' ')
fi

kill_listeners "$target"

case $target in
    :*)
        socat_listen="UNIX-LISTEN:/tmp/.X11-unix/X$(display_num "$target"),fork,unlink-early"
        ;;
    *)
        socat_listen="TCP-LISTEN:$((6000 + $(display_num "$target"))),fork"
        ;;
esac

case $DISPLAY in
    :*)
        socat_connect="UNIX-CONNECT:/tmp/.X11-unix/X$(display_num "$DISPLAY")"
        ;;
    *)
        socat_connect="TCP-CONNECT:localhost:$((6000 + $(display_num "$DISPLAY")))"
        ;;
esac

( socat "$socat_listen" "$socat_connect" & )
