source $ZPLUG_HOME/init.zsh

# plugins
zplug "zplug/zplug", hook-build:"zplug --self-manage"
zplug "mafredri/zsh-async", from:github, use:"async.zsh"
zplug "sindresorhus/pure", from:github, use:"pure.zsh", as:theme
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions", defer:2

# check for new plugins
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# install plugins
zplug load