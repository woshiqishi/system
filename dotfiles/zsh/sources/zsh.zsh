# history
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=5000

# settings: history
setopt histignorealldups
setopt sharehistory
setopt interactive_comments
# settings: cd
setopt autocd
# patterns
setopt extended_glob
# disable beep
unsetopt beep notify

# emacs keybindings
bindkey -e