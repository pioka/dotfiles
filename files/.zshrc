# Aliases & Functions
alias ls='ls -h --color=auto'
#alias ls='ls -Gh' # for Mac
alias l='ls -CF'
alias ll='ls -alF'
alias la='ls -A'
alias p='ping -c 10 -i 0.2'
alias vim='nvim'

function show-https-cert() {
  openssl s_client -connect $1:443 -servername $1 < /dev/null | openssl x509 -noout -text
}

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
zstyle ':vcs_info:svn:*' formats '[%r > r%i%c%u%m]'
zstyle ':vcs_info:git:*' formats '[%r > %b%c%u%m]'
zstyle ':vcs_info:git:*' actionformats '[%r > %b%c%u<%B%F{red}%a%f%%b>%m]'

PROMPT='
[%n@%F{cyan}%B%m%b%f:%F{blue}%B%~%b%f] ${vcs_info_msg_0_}
%# '

precmd() {
  git-auto-fetch
  vcs_info
  print -Pn "\e]0;%n@%M:%~\a"
}


# Add path
path+=~/.local/bin

# AutoSuggestions
if [ ! -e ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# asdf
if [ ! -e ~/.asdf/asdf.sh ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf -b v0.8.0
fi
source $HOME/.asdf/asdf.sh


# git: Display ahead/behind
zstyle ':vcs_info:git*+set-message:*' hooks git-st
function +vi-git-st() {
    local ahead behind

    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
    
    (( $behind+$ahead )) && hook_com[misc]+=" (-${behind}/+${ahead})"
}

# git: Auto fetch
# `touch .git/NO_AUTO_FETCH` to disable
function git-auto-fetch() {
  FETCH_INTERVAL_SEC=3600
  
  git rev-parse --is-inside-work-tree > /dev/null 2>&1 || return
  gitdir=`git rev-parse --git-dir`
  [[ -f $gitdir/NO_AUTO_FETCH ]] && return
  (( `date +%s` - `date -r $gitdir/FETCH_LOG +%s 2>/dev/null || echo 0` > $FETCH_INTERVAL_SEC )) && \
    git fetch --all | tee $gitdir/FETCH_LOG 
}
