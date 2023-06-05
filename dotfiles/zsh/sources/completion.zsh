# menu highlight on tab
zstyle ':completion:*' menu select

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' list-suffixes true
zstyle :compinstall filename '/home/wasp/.zshrc'

autoload -Uz compinit; compinit
