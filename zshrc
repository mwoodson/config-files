#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
WORDCHARS="${WORDCHARS:s#/#}"
WORDCHARS="${WORDCHARS:s#.#}"
##############################################################
#key binding stuff to get the right keys to work
# key bindings
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" overwrite-mode
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\ee[C" forward-word
bindkey "\ee[D" backward-word
#bindkey "^H" backward-delete-word
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for non RH/Debian xterm, cant hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix
#########################################################################

setopt appendhistory autocd nobeep extendedglob nomatch notify
setopt autolist auto_menu
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/mwoodson/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
## completion system
_force_rehash() {
      (( CURRENT == 1 )) && rehash
          return 1  # Because we didn't really complete anything
}

zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete ...

zstyle ':completion:*:approximate:'    max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )' # allow one error for every three characters typed in approximate completer
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~' # don't complete backup files as executables
zstyle ':completion:*:correct:*'       insert-unambiguous true             # start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}' #
zstyle ':completion:*:correct:*'       original true                       #
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}      # activate color-completion(!)
zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'  # format on completion
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select              # complete 'cd -<tab>' with menu
#zstyle ':completion:*:expand:*'        tag-order all-expansions            # insert all expansions for expand completer
zstyle ':completion:*:history-words'   list false                          #
zstyle ':completion:*:history-words'   menu yes                            # activate menu
zstyle ':completion:*:history-words'   remove-all-dups yes                 # ignore duplicate entries
zstyle ':completion:*:history-words'   stop yes                            #
zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'        # match uppercase from lowercase
zstyle ':completion:*:matches'         group 'yes'                         # separate matches into groups
zstyle ':completion:*'                 group-name ''
zstyle ':completion:*:messages'        format '%d'                         #
zstyle ':completion:*:options'         auto-description '%d'               #
zstyle ':completion:*:options'         description 'yes'                   # describe options in full
zstyle ':completion:*:processes'       command 'ps -au$USER'               # on processes completion complete all user processes
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters        # offer indexes before parameters in subscripts
zstyle ':completion:*'                 verbose true                        # provide verbose completion information
zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d' # set format for warnings
zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'       # define files to ignore for zcompile
zstyle ':completion:correct:'          prompt 'correct to: %e'             #
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'    # Ignore completion functions for commands you don't have:

# complete manual by their section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select



# Completion caching
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path .zcache
zstyle ':completion:*:cd:*' ignore-parents parent pwd

zstyle ':completion::complete:cd::' tag-order local-directories
zstyle ':completion:*' menu select=2
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

CDPATH=.:~:~/git

# Custom commands
glob_scp() {
    emulate -L zsh
    local -a args
    local a
    for a
    do
    if [[ $a = *:* ]]
    then
            args+=($a)  # args+=($a) if you have zsh 4.2+
    else
            args+=($~a) # args+=($~a)
    fi
    done
    scp $args
}

glob_rsync() {
    emulate -L zsh
    local -a args
    local a
    for a
    do
    if [[ $a = *:* ]]
    then
            args+=($a) # args+=($a) if you have zsh 4.2+
    else
            args+=($~a) # args+=($~a)
    fi
    done
    rsync --progress $args
}

#setup ~/.dir_colors if one doesn't exist
if [ ! -s ~/.dir_colors ]; then
    dircolors -p > ~/.dir_colors
fi
eval `dircolors ~/.dir_colors`

#aliases
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias scp='noglob glob_scp'
alias rsync='noglob glob_rsync'
alias  vi=$(which vim)
alias -- -='cd -'
alias  ...='../..'
alias  ....='../../..'
alias  .....='../../../..'
alias  ll='ls -lah'
alias  sl='ls -lah'
alias  l='ls -la'
alias -g X='| xargs'
alias -g G='| egrep'

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD
setopt CORRECT

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
#setopt APPEND_HISTORY
## for sharing history between zsh processes
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

## never ever beep ever
setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

autoload -U colors
colors
# set some colors
for COLOR in RED GREEN YELLOW WHITE BLACK CYAN BLUE PURPLE; do
    eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'         
    eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done                                                 
PR_RESET="%{${reset_color}%}";                       

setopt prompt_subst
 
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git cvs svn
# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stangedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
## check-for-changes can be really slow.
## you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true            # slower, but lets us show changes to working/index
zstyle ':vcs_info:*:prompt:*' unstagedstr "${PR_BRIGHT_YELLOW}*${PR_RESET}"             # unstaged changes string: red *
zstyle ':vcs_info:*:prompt:*' stagedstr "${PR_BRIGHT_YELLOW}+${PR_RESET}"            # staged changes string: yellow +
zstyle ':vcs_info:*:prompt:*' formats  " ${PR_GREEN}%s${PR_RESET}:${PR_BRIGHT_RED}(%b${PR_RESET}%c%u${PR_BRIGHT_RED})${PR_RESET}"              "%a"
zstyle ':vcs_info:*:prompt:*' actionformats  " ${PR_GREEN}%s${PR_RESET}:${PR_BRIGHT_RED}(%b|%a)${PR_RESET}"              "%a"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""                             "%~"
zstyle ':vcs_info:*:prompt:*' branchformat  "%b:%r"              ""

BLUE_DIAMOND="${PR_BRIGHT_BLUE}◆${PR_RESET}"

precmd(){
    vcs_info 'prompt'

    # Battery Stuff
    if which ibam &> /dev/null; then
        IBAMSTAT="$(ibam)"
        if [[ ${IBAMSTAT[(f)(1)][(w)1]} =  "Battery" ]]; then
            BATTSTATE="$(ibam --percentbattery)"
            BATTPRCNT="${BATTSTATE[(f)1][(w)-2]}"
            BATTTIME="${BATTSTATE[(f)2][(w)-1]}"
            PR_BATTERY="Bat: ${BATTPRCNT}%% (${BATTTIME})"
            if [[ "${BATTPRCNT}" -lt 15 ]]; then
                PR_BATTERY=" ${BLUE_DIAMOND} ${PR_BRIGHT_RED}${PR_BATTERY}"
            elif [[ "${BATTPRCNT}" -lt 50 ]]; then
                PR_BATTERY=" ${BLUE_DIAMOND} ${PR_BRIGHT_YELLOW}${PR_BATTERY}"
            elif [[ "${BATTPRCNT}" -lt 100 ]]; then
                PR_BATTERY=" ${BLUE_DIAMOND} ${PR_BRIGHT_CYAN}${PR_BATTERY}${PR_RESET}"
            else
                PR_BATTERY=""
            fi
        else
            PR_BATTERY=""
        fi
    fi
    ###End of Battery Stuff######

    # now let's change the color of the path if it's not writable
    if [[ -w $PWD ]]; then
        PR_PWDCOLOR="${PR_YELLOW}"
    else
        PR_PWDCOLOR="${PR_BRIGHT_RED}"
    fi  

}

if [[ $(whoami) = root ]]; then
    PROMPT_LINE="${PR_BRIGHT_RED}%n@%M${PR_RESET}"
else
    PROMPT_LINE="${PR_GREEN}%n${PR_RESET}@${PR_BRIGHT_BLUE}%m${PR_RESET}"
fi

PROMPT='\
${PR_BRIGHT_BLACK}▶${PR_RESET}${PR_RED}▶${PR_BRIGHT_RED}▶${PR_RESET} \
${PR_BRIGHT_GREEN}%D{%R.%S %a %b %d %Y}${PR_RESET}\
%(?.. ${PR_BRIGHT_BLUE}◆${PR_RESET} ${PR_BRIGHT_YELLOW}Exit Code: %?${PR_RESET})\
${PR_BATTERY}\
 ${PR_BRIGHT_RED}◀${PR_RESET}${PR_RED}◀${PR_BRIGHT_BLACK}◀${PR_RESET}
${PROMPT_LINE}${PR_BRIGHT_GREEN}:${PR_RESET}${PR_PWDCOLOR}%~${PR_RESET}${vcs_info_msg_0_}%(!.${PR_BRIGHT_RED}%#${PR_RESET}.${PR_BRIGHT_GREEN}➤${PR_RESET}) '
