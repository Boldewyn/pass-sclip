#!/usr/bin/env bash

clip() {
    if [[ ! $STY ]]; then
        echo "This seems to be no screen session. Exiting." >&2
        exit 1
    fi

    local sleep_argv0="password store sleep on display $DISPLAY"
    pkill -f "^$sleep_argv0" 2>/dev/null && sleep 0.5

    SCREEN_EXCHANGE=$(mktemp --tmpdir tmp.pass.sclip.XXXXXXXX)
    SCREEN_BEFORE=$(mktemp --tmpdir tmp.pass.sclip_before.XXXXXXXX)

    # do not clear SCREEN_BEFORE on exit, b/c the disowned shell below
    # still needs it after this one exits.
    trap "{ rm -f '$SCREEN_EXCHANGE'; }" EXIT

    # store previous clipboard content
    screen -X writebuf "$SCREEN_BEFORE"

    # write password to tmp file. It would be better if screen could read it
    # from stdin somehow, but alas, that doesn't work.
    echo -n "$1" > "$SCREEN_EXCHANGE"

    # let screen read it
    screen -X readbuf "$SCREEN_EXCHANGE"

    # remove the tmp file immediately
    rm -f "$SCREEN_EXCHANGE"

    # restore the clipboard state after CLIP_TIME
    (
        ( exec -a "$sleep_argv0" sleep "$CLIP_TIME" )
        screen -X readbuf "$SCREEN_BEFORE"
        rm -f "$SCREEN_BEFORE"
    ) 2>/dev/null & disown

    echo "Copied $2 to screen clipboard. Will clear in $CLIP_TIME seconds."
}

cmd_show --clip "$@"
