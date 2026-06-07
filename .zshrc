# Add PATH
export PATH=~/.local/bin:$PATH



# Aliases & Functions
## general
alias t='test -n "$TMUX" || tmux attach || tmux'
alias p='ping -c 10 -i 0.2'

alias ls='ls -h --color=auto'
alias l='ls -CF'
alias ll='ls -alF'
alias la='ls -A'

## nvim
alias nview='nvim -R'
alias nvimdiff='nvim -d'

## claude --dangerously-skip-permissions with sandbox
function claude-sp() {
  (exec bwrap --new-session --die-with-parent --unshare-all --share-net \
    --dev /dev \
    --proc /proc \
    --dir /var \
    --dir /tmp \
    --ro-bind /usr /usr \
    --ro-bind /etc/resolv.conf /etc/resolv.conf \
    --symlink /tmp /var/tmp \
    --symlink /usr/lib /lib \
    --symlink /usr/lib64 /lib64 \
    --symlink /usr/bin /bin \
    --symlink /usr/sbin /sbin \
    --dir /run/user/$(id -u) \
    --file 3 /etc/passwd \
    --file 4 /etc/group \
    --bind "$HOME/.claude" "$HOME/.claude" \
    --bind "$HOME/.claude.json" "$HOME/.claude.json" \
    --ro-bind "$HOME/.local" "$HOME/.local" \
    --ro-bind "$HOME/.asdf" "$HOME/.asdf" \
    --ro-bind "$HOME/.tool-versions" "$HOME/.tool-versions" \
    --ro-bind "$HOME/.gitconfig" "$HOME/.gitconfig" \
    --ro-bind "$HOME/.gitconfig.local" "$HOME/.gitconfig.local" \
    --chdir "$(pwd)" \
    --bind "$(pwd)" "$(pwd)" \
    "$(which claude)" --dangerously-skip-permissions) \
    3< <(getent passwd $(id -u) 65534) \
    4< <(getent group $(id -g) 65534)
}

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
HISTSIZE=1000000
SAVEHIST=1000000



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
zstyle ':vcs_info:svn:*' formats '[%s:r%i%c%u%m]'
zstyle ':vcs_info:git:*' formats '[%s:%b%c%u%m]'
zstyle ':vcs_info:git:*' actionformats '[%r > %b%c%u<%B%F{red}%a%f%%b>%m]'

## `export PROMPT_HOSTNAME_COLOR=xxx`
## to change hostname color. default is white.
PROMPT='
[%n@%F{${PROMPT_HOSTNAME_COLOR:-white}}%B%m%b%f:%F{blue}%B%~%b%f] ${vcs_info_msg_0_}
%# '



# Hooks
autoload -Uz add-zsh-hook

## vcs_info
add-zsh-hook precmd vcs_info

## print terminal titlebar text
add-zsh-hook precmd _precmd_print_titlebar_text
function _precmd_print_titlebar_text() {
  print -Pn "\e]0;%n@%M:%~\a"
}

## display git ahead/behind
zstyle ':vcs_info:git*+set-message:*' hooks git-st
function +vi-git-st() {
    local ahead behind

    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

    (( $behind+$ahead )) && hook_com[misc]+=" (-${behind}/+${ahead})"
}



# tools setup
source ~/.zsh/init-tools.zsh
