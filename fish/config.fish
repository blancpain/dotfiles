if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
    source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
end

if test -d /run/current-system/sw/bin
    fish_add_path /run/current-system/sw/bin
end

# secrets
# to set use: echo "set -gx KEY_NAME the_actual_key" | openssl enc -base64 >> .secrets.enc
# file needs to sit in fish root path /fish/
if test -f $HOME/dotfiles/fish/.secrets.enc
    openssl enc -base64 -d <$HOME/dotfiles/fish/.secrets.enc | source
end

#https://fishshell.com/docs/current/language.html
set -U fish_greeting # disable fish greeting

#inits
set -x STARSHIP_CONFIG $HOME/.config/starship/starship.toml
starship init fish | source # https://starship.rs/
zoxide init fish | source # 'ajeetdsouza/zoxide'

#PATH
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path /opt/homebrew/opt/sqlite/bin
fish_add_path $GOPATH/bin
fish_add_path $HOME/.npm-global/bin/
fish_add_path $HOME/.config/bin # custom scripts; currently empty
fish_add_path /Applications/Postgres.app/Contents/Versions/15/bin
fish_add_path /Users/blancpain/.local/share/bob/nvim-bin #nvim bob
fish_add_path /Users/blancpain/.cargo/bin

#settings
set -Ux EDITOR nvim
set -Ux VISUAL nvim
set -U FZF_CTRL_R_OPTS "--border-label=' Command History ' --prompt=' '"
set -U FZF_DEFAULT_COMMAND "fd -H -E '.git'"
set -U FZF_DEFAULT_OPTS "--reverse --no-info --prompt=' ' --pointer='' --marker='' --ansi --color gutter:-1,bg+:-1,header:4,separator:0,info:0,label:4,border:4,prompt:7,pointer:5,query:7,prompt:7"
set -U FZF_TMUX_OPTS "-p --no-info --ansi --color gutter:-1,bg+:-1,header:4,separator:0,info:0,label:4,border:4,prompt:7,pointer:5,query:7,prompt:7"
set -U GOPATH (go env GOPATH) # https://golang.google.cn/
set -x OP_BIOMETRIC_UNLOCK_ENABLED true
set -x XDG_CONFIG_HOME "/Users/blancpain/.config"
set -x NIX_CONF_DIR "/Users/blancpain/.config/nix"
set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
carapace _carapace | source

#abbreviations
abbr vim nvim
abbr vi nvim
abbr v nvim
abbr p python3
abbr y yazi
abbr g lazygit
abbr tn "tmux new -s (pwd | sed 's/.*\///g')"
abbr gc git clone
abbr gp git pull
abbr gP git push
abbr cr cargo run
abbr cb cargo build
abbr bu "brew update && brew upgrade"
abbr dr "darwin-rebuild switch --flake ~/dotfiles/nix-darwin"

fzf_configure_bindings --directory=\cf

# Added by Windsurf
fish_add_path /Users/blancpain/.codeium/windsurf/bin

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /Users/blancpain/miniforge3/bin/conda
    eval /Users/blancpain/miniforge3/bin/conda "shell.fish" hook $argv | source
else
    if test -f "/Users/blancpain/miniforge3/etc/fish/conf.d/conda.fish"
        . "/Users/blancpain/miniforge3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH /Users/blancpain/miniforge3/bin $PATH
    end
end

if test -f "/Users/blancpain/miniforge3/etc/fish/conf.d/mamba.fish"
    source "/Users/blancpain/miniforge3/etc/fish/conf.d/mamba.fish"
end
# <<< conda initialize <<<

# Added by Windsurf
fish_add_path /Users/blancpain/.codeium/windsurf/bin

# Added by Windsurf
fish_add_path /Users/blancpain/.codeium/windsurf/bin
