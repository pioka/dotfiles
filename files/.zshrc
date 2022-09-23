# Add PATH
export PATH=~/.local/bin:$PATH

# Aliases & Functions
## general
alias t='tmux attach || tmux'
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
  -print-cmd-start-time
}

precmd() {
  local cmd_status=$?
  -print-cmd-end-time
  -git-auto-fetch
  vcs_info
  print -Pn "\e]0;%n@%M:%~\a"
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
## `touch .git/NO_AUTO_FETCH` to disable
function -git-auto-fetch() {
  FETCH_INTERVAL_SEC=3600

  git rev-parse --is-inside-work-tree > /dev/null 2>&1 || return
  gitdir=`git rev-parse --git-dir`
  [[ -f $gitdir/NO_AUTO_FETCH ]] && return
  (( `date +%s` - `date -r $gitdir/FETCH_LOG +%s 2>/dev/null || echo 0` > $FETCH_INTERVAL_SEC )) && \
    git fetch --all | tee $gitdir/FETCH_LOG 
}

function -print-cmd-start-time() {
  _cmd_running=1
  echo -e "\e[90m<<< $(date '+%Y-%m-%d %H:%M:%S')\e[m"
}

function -print-cmd-end-time() {
  if [ "$_cmd_running" = "1" ]; then
    echo -e "\e[90m>>> $(date '+%Y-%m-%d %H:%M:%S') ($cmd_status)\e[m"
  fi
  _cmd_running=0
}

source ~/.zsh/init-tools.zsh
