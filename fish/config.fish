if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
    source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
end

if test -d /run/current-system/sw/bin
    fish_add_path /run/current-system/sw/bin
end

if test -d "$HOME/.nix-profile/bin"
    fish_add_path "$HOME/.nix-profile/bin"
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
# macOS-specific paths
if test (uname) = Darwin
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/sbin
    fish_add_path /opt/homebrew/opt/sqlite/bin
    fish_add_path /Applications/Postgres.app/Contents/Versions/15/bin
    fish_add_path $HOME/.codeium/windsurf/bin
end

# Common paths (both macOS and Linux)
fish_add_path $GOPATH/bin
fish_add_path $HOME/.config/bin # custom scripts; currently empty
fish_add_path $HOME/.local/share/bob/nvim-bin #nvim bob
fish_add_path $HOME/.cargo/bin

# macOS-specific aliases
if test (uname) = Darwin
    alias influxdb="$HOME/.influxdb/influxdb3"
end

#settings
set -Ux EDITOR nvim
set -Ux VISUAL nvim

# Set FZF clipboard command based on OS
if test (uname) = Darwin
    set -U FZF_CTRL_R_OPTS "--border-label=' Command History ' --prompt=' ' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --color header:italic --header 'Press CTRL-Y to copy command into clipboard'"
else
    # Linux: check for available clipboard tools
    if command -v xclip >/dev/null
        set -U FZF_CTRL_R_OPTS "--border-label=' Command History ' --prompt=' ' --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -selection clipboard)+abort' --color header:italic --header 'Press CTRL-Y to copy command into clipboard'"
    else if command -v wl-copy >/dev/null
        set -U FZF_CTRL_R_OPTS "--border-label=' Command History ' --prompt=' ' --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort' --color header:italic --header 'Press CTRL-Y to copy command into clipboard'"
    else
        set -U FZF_CTRL_R_OPTS "--border-label=' Command History ' --prompt=' ' --bind 'ctrl-y:accept' --color header:italic --header 'Press CTRL-Y to accept command'"
    end
end

set -U FZF_DEFAULT_COMMAND "fd -H -E '.git'"
set -U FZF_DEFAULT_OPTS "--reverse --no-info --prompt=' ' --pointer='' --marker='' --ansi --color gutter:-1,bg+:-1,header:4,separator:0,info:0,label:4,border:4,prompt:7,pointer:5,query:7,prompt:7"
set -U FZF_TMUX_OPTS "-p --no-info --ansi --color gutter:-1,bg+:-1,header:4,separator:0,info:0,label:4,border:4,prompt:7,pointer:5,query:7,prompt:7"
set -U fzf_fd_opts --hidden --exclude .git
set -U GOPATH (go env GOPATH) # https://golang.google.cn/
set -x OP_BIOMETRIC_UNLOCK_ENABLED true

if test (uname) = Darwin
    set -x XDG_CONFIG_HOME "$HOME/.config"
    set -x NIX_CONF_DIR "$HOME/.config/nix"
else
    set -x XDG_CONFIG_HOME "$HOME/.config"
    set -x NIX_CONF_DIR "$HOME/.config/nix"
end

set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
carapace _carapace | source

# Set browser only on macOS
if test (uname) = Darwin
    set -gx BROWSER "/Applications/Arc.app/Contents/MacOS/Arc"
end

#helpers
function nix_darwin_update --description 'Run nix flake update in ~/dotfiles/nix-darwin'
    set -l repo "$HOME/dotfiles/nix-darwin"
    if not test -d $repo
        printf 'nix flake repo not found: %s\n' $repo >&2
        return 1
    end

    pushd $repo >/dev/null; or return 1
    nix flake update $argv
    set -l cmd_status $status
    popd >/dev/null
    return $cmd_status
end

#abbreviations
abbr vim nvim
abbr vi nvim
abbr v nvim
abbr p python3
abbr y yazi
abbr g lazygit
abbr d lazydocker
abbr tn "tmux new -s (pwd | sed 's/.*\///g')"
abbr gc git clone
abbr gp git pull
abbr gP git push
abbr car cargo run
abbr cab cargo build
abbr du nix_darwin_update

# Platform-specific abbreviations
if test (uname) = Darwin
    abbr c "pwd | pbcopy"
    abbr bu "brew update && brew upgrade"
    abbr dr "sudo darwin-rebuild switch --flake ~/dotfiles/nix-darwin#mac"
else
    # Linux clipboard abbreviation
    if command -v xclip >/dev/null
        abbr c "pwd | xclip -selection clipboard"
    else if command -v wl-copy >/dev/null
        abbr c "pwd | wl-copy"
    end
    # WSL/Linux: quick home-manager switch with backups
    abbr hms 'home-manager switch -b backup --flake ~/dotfiles/nix-darwin#blancpain@linux'
end

fzf_configure_bindings --directory=\cf

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f $HOME/miniforge3/bin/conda
    eval $HOME/miniforge3/bin/conda "shell.fish" hook $argv | source
else
    if test -f "$HOME/miniforge3/etc/fish/conf.d/conda.fish"
        . "$HOME/miniforge3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH $HOME/miniforge3/bin $PATH
    end
end

if test -f "$HOME/miniforge3/etc/fish/conf.d/mamba.fish"
    source "$HOME/miniforge3/etc/fish/conf.d/mamba.fish"
end
# <<< conda initialize <<<
