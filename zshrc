#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd nobeep extendedglob nomatch notify
setopt autolist auto_menu
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/mwoodson/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

zstyle ':completion:*' menu select=2
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

CDPATH=.:~:~/git

#aliases
alias -g vi=$(which vim)
alias -g -- -='cd -'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ll='ls -lah'
alias -g sl='ls -lah'
alias -g l='ls -la'
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
zstyle ':vcs_info:*' enable git                                 # only enable git/git-svn
zstyle ':vcs_info:*:prompt:*' check-for-changes true            # slower, but lets us show changes to working/index
zstyle ':vcs_info:*:prompt:*' unstagedstr "${PR_BRIGHT_YELLOW}*${PR_RESET}"             # unstaged changes string: red *
zstyle ':vcs_info:*:prompt:*' stagedstr "${PR_BRIGHT_YELLOW}+${PR_RESET}"            # staged changes string: yellow +
zstyle ':vcs_info:*:prompt:*' formats  " ${PR_GREEN}%s${PR_RESET}:${PR_BRIGHT_RED}(%b${PR_RESET}%c%u${PR_BRIGHT_RED})${PR_RESET}"              "%a"
zstyle ':vcs_info:*:prompt:*' actionformats  " ${PR_GREEN}%s${PR_RESET}:${PR_BRIGHT_RED}(%b|%a)${PR_RESET}"              "%a"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""                             "%~"

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
