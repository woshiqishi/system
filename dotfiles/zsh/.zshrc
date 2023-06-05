for file in "$HOME/system/dotfiles/zsh/sources"/*.zsh; do
    [[ -r "$file" ]] && source "$file"
done

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' insert-tab pending