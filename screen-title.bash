#!/bin/bash -x

# By Glyph Lefkowitz
# Modified by Alex Wood
# Modified by Matt Woodson

# xterm-title.sh -- This script uses the precmd and preexec facilities created
# in preexec.sh to change the title of the xterm (or screen) window to reflect
# the current command being run.

# Change the title of the xterm.
function preexec_xterm_title () {
    local title="$1"
    echo -ne "\e]0;$title\007"
}

# Change the title of a screen
function preexec_screen_title () {
    local title="$1"
    echo -ne "\ek$1\e\\"
}

function abbreviate_path () {
    # Replace instances of $HOME in $PWD with ~.  `dirs -0` does it too, but slower.
    local working_dir="${PWD/#$HOME/~}"
    if [[ $working_dir != "~" ]]
    then
        #E.g. /usr/local/share becomes share/
        local working_dir="${PWD##/*/}/"
    fi

    echo $working_dir
}

# Don't bother changing the title for commands that take very little time.  
# Eliminates an annoying flicker on the title bar.
function display_command () {
    local banned_commands=( 'ls' 'cd' 'bg' 'fg' 'pwd' 'pushd' 'popd' )
    for cmd in "${banned_commands[@]}"
    do
        if [[ "$1" == "$cmd" ]]
        then
            return 1
        fi
    done

    return 0
}

function precmd () {
    # Strip off everything past the first period in the hostname.  hostname -s will
    # do this, but using the bash built-in is faster.
    preexec_xterm_title "${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}"

    if [[ $TERM == "screen" ]]
    then
        NHN=$(echo $HOSTNAME | awk -F . '{print $1}')
        preexec_screen_title $NHN
        #preexec_screen_title `abbreviate_path`
    fi
}

function preexec () {
    # Give me the command name sans any arguments
    local cutit="$1"
    local cmdtitle=`echo "$cutit" | cut -d " " -f 1`

    if display_command "$cmdtitle"
    then
        preexec_xterm_title "$1 (${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~})"
        if [[ $TERM == "screen" ]]
        then
            if [[ $(basename $cmdtitle) == "ssh" ]]; then
                SHN=$(echo $1 | sed 's/ .*\@/ /' | awk '{print $NF}')
                echo "SHN=$SHN"
                SHN_COUNT=$(echo $SHN | awk -F . '{print NF}')
                case $SHN_COUNT in
                    [1-2])
                        preexec_screen_title $SHN
                        #echo -n "\033k$SHN\033\\"
                    ;;
                    3)
                        NSHN=$(echo $SHN | awk -F . '{print $1}')
                        preexec_screen_title $NSHN
                    ;;
                    *)
                        NSHN=$(echo $SHN | awk -F . '{print $1 "."  $2  "."  $3}')
                        preexec_screen_title $NSHN
                    ;;
                esac
            fi

            # if the user invoked screen with a command (e.g. "screen links")
            # the value of $1 is exec which isn't very useful.
        fi
    fi
}

if [[ $TERM == "xterm" || $TERM == "screen" ]]
then
    preexec_install
fi

