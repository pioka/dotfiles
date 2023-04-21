# Add PATH
export PATH=~/.local/bin:$PATH

# Aliases & Functions
## general
alias t='test -n "$TMUX" || tmux attach || tmux'
if [ -n "$TMUX_AUTO_LAUNCH" ]; then t; fi
alias p='ping -c 10 -i 0.2'

## ls
if [ "`uname -s`" = "Darwin" ]; then
  ### macOS
  alias ls='ls -Gh'
else
  #### Others
  alias ls='ls -h --color=auto'
fi
alias l='ls -CF'
alias ll='ls -alF'
alias la='ls -A'

## nvim
alias nview='nvim -R'
alias nvimdiff='nvim -d'

function show-https-cert() {
  openssl s_client -connect $1:443 -servername $1 < /dev/null | openssl x509 -noout -text
}

# Keymap: Emacs
bindkey -e

# History
setopt extended_history
setopt share_history
setopt hist_ignore_dups
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=10000


# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*:default' menu select=1


# Display
export PROMPT_EOL_MARK=''
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%B%F{green}+%f%b'
zstyle ':vcs_info:*' unstagedstr '%B%F{magenta}*%f%b'
zstyle ':vcs_info:svn:*' formats '[%r:r%i%c%u%m]'
zstyle ':vcs_info:git:*' formats '[%r:%b%c%u%m]'
zstyle ':vcs_info:git:*' actionformats '[%r > %b%c%u<%B%F{red}%a%f%%b>%m]'

## `export PROMPT_HOSTNAME_COLOR=xxx`
## to change hostname color. default is cyan.
PROMPT='
[%n@%F{${PROMPT_HOSTNAME_COLOR:-cyan}}%B%m%b%f:%F{blue}%B%~%b%f] ${vcs_info_msg_0_}
%# '


# Hooks
preexec() {
  _ZSH_CMD_RUNNING=1
  _ZSH_CMD_STARTED_AT=$(date +%s)
}

precmd() {
  _ZSH_CMD_STATUS=$?
  _zsh_print_cmd_stats
  _ZSH_CMD_RUNNING=0
  _zsh_git_auto_fetch
  vcs_info

  # Print title bar text
  print -Pn "\e]0;%n@%M:%~\a"
}

function _zsh_print_cmd_stats() {
  test "$_ZSH_CMD_RUNNING" != 1 && return

  local cmd_duration=$(($(date +%s) - ${_ZSH_CMD_STARTED_AT}))
  if [ $cmd_duration = 0 ]; then
    echo -e "\e[90m>>> returned $_ZSH_CMD_STATUS, took <1s\e[m"
  else
    echo -e "\e[90m>>> returned $_ZSH_CMD_STATUS, took ${cmd_duration}s\e[m"
  fi
}

## git: Display ahead/behind
zstyle ':vcs_info:git*+set-message:*' hooks git-st
function +vi-git-st() {
    local ahead behind

    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

    (( $behind+$ahead )) && hook_com[misc]+=" (-${behind}/+${ahead})"
}

## git: Auto fetch
function _zsh_git_auto_fetch() {
  FETCH_INTERVAL_SEC=3600
  git rev-parse --is-inside-work-tree >& /dev/null || return

  local gitdir=`git rev-parse --git-dir`
  test -f $gitdir/NO_AUTO_FETCH && return
  if [ $(( $(date +%s) - $(date -r $gitdir/FETCH_LOG +%s 2> /dev/null || echo 0) )) -gt $FETCH_INTERVAL_SEC ]; then
    echo "Running auto-fetch. \`touch $gitdir/NO_AUTO_FETCH\` to disable."
    git fetch --all | tee $gitdir/FETCH_LOG 
  fi
}

source ~/.zsh/init-tools.zsh
