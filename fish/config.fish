# Cache expensive operations using universal variables (persists across sessions)
# Only run these checks if not already cached
if not set -q IS_MACOS
    set -Ux IS_MACOS (test (uname) = Darwin; and echo 1; or echo 0)
end
if not set -q HAS_XCLIP
    set -Ux HAS_XCLIP (command -v xclip >/dev/null; and echo 1; or echo 0)
end
if not set -q HAS_WLCOPY
    set -Ux HAS_WLCOPY (command -v wl-copy >/dev/null; and echo 1; or echo 0)
end

if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
    source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
end

if test -d /run/current-system/sw/bin
    fish_add_path /run/current-system/sw/bin
end

if test -d "$HOME/.nix-profile/bin"
    fish_add_path "$HOME/.nix-profile/bin"
end

# secrets (lazy-loaded on first command)
# to set use: echo "set -gx KEY_NAME the_actual_key" | openssl enc -base64 >> .secrets.enc
# file needs to sit in fish root path /fish/
set -g __secrets_loaded 0
function __load_secrets_once --on-event fish_preexec
    if test $__secrets_loaded -eq 0
        set -g __secrets_loaded 1
        if test -f $HOME/dotfiles/fish/.secrets.enc
            openssl enc -base64 -d <$HOME/dotfiles/fish/.secrets.enc | source
        end
    end
end

#https://fishshell.com/docs/current/language.html
set -U fish_greeting # disable fish greeting

#inits
set -x STARSHIP_CONFIG $HOME/.config/starship/starship.toml
starship init fish | source # https://starship.rs/
carapace _carapace | source
set -U fish_pager_color_description yellow # make descriptions in pager yellow

# Lazy-load zoxide on first command
set -g __zoxide_loaded 0
function __load_zoxide_once --on-event fish_preexec
    if test $__zoxide_loaded -eq 0
        set -g __zoxide_loaded 1
        zoxide init fish | source
    end
end

#PATH
# macOS-specific paths
if test $IS_MACOS -eq 1
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
if test $IS_MACOS -eq 1
    alias influxdb="$HOME/.influxdb/influxdb3"
end

#settings
set -gx EDITOR nvim
set -gx VISUAL nvim

# Set FZF clipboard command based on OS
if test $IS_MACOS -eq 1
    set -U FZF_CTRL_R_OPTS "--border-label=' Command History ' --prompt=' ' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --color header:italic --header 'Press CTRL-Y to copy command into clipboard'"
else
    # Linux: check for available clipboard tools
    if test $HAS_XCLIP -eq 1
        set -U FZF_CTRL_R_OPTS "--border-label=' Command History ' --prompt=' ' --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -selection clipboard)+abort' --color header:italic --header 'Press CTRL-Y to copy command into clipboard'"
    else if test $HAS_WLCOPY -eq 1
        set -U FZF_CTRL_R_OPTS "--border-label=' Command History ' --prompt=' ' --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort' --color header:italic --header 'Press CTRL-Y to copy command into clipboard'"
    else
        set -U FZF_CTRL_R_OPTS "--border-label=' Command History ' --prompt=' ' --bind 'ctrl-y:accept' --color header:italic --header 'Press CTRL-Y to accept command'"
    end
end

set -U FZF_DEFAULT_COMMAND "fd -H -E '.git'"
set -U FZF_DEFAULT_OPTS "--reverse --no-info --prompt=' ' --pointer='' --marker='' --ansi --color gutter:-1,bg+:-1,header:4,separator:0,info:0,label:4,border:4,prompt:7,pointer:5,query:7,prompt:7"
set -U FZF_TMUX_OPTS "-p --no-info --ansi --color gutter:-1,bg+:-1,header:4,separator:0,info:0,label:4,border:4,prompt:7,pointer:5,query:7,prompt:7"
set -U fzf_fd_opts --hidden --exclude .git
# Cache GOPATH instead of calling `go env` every time
if not set -q GOPATH
    set -Ux GOPATH (go env GOPATH) # https://golang.google.cn/
end
set -x OP_BIOMETRIC_UNLOCK_ENABLED true

# XDG dirs are the same on both platforms
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x NIX_CONF_DIR "$HOME/.config/nix"

# Set browser only on macOS
if test $IS_MACOS -eq 1
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
if test $IS_MACOS -eq 1
    abbr c "pwd | pbcopy"
    abbr bu "brew update && brew upgrade"
    abbr dr "sudo darwin-rebuild switch --flake ~/dotfiles/nix-darwin#mac"
else
    # Linux clipboard abbreviation
    if test $HAS_XCLIP -eq 1
        abbr c "pwd | xclip -selection clipboard"
    else if test $HAS_WLCOPY -eq 1
        abbr c "pwd | wl-copy"
    end
    # WSL/Linux: invoke home-manager via nix run (works even if HM binary isn't on PATH)
    abbr hms 'nix run --extra-experimental-features "nix-command flakes" home-manager/master -- switch -b backup --flake ~/dotfiles/nix-darwin#blancpain@linux'
    function hm_update --description 'Run nix flake update in ~/dotfiles/nix-darwin (Linux/WSL)'
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
    abbr hu hm_update
end

fzf_configure_bindings --directory=\cf

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# if test -f $HOME/miniforge3/bin/conda
#     eval $HOME/miniforge3/bin/conda "shell.fish" hook $argv | source
# else
#     if test -f "$HOME/miniforge3/etc/fish/conf.d/conda.fish"
#         . "$HOME/miniforge3/etc/fish/conf.d/conda.fish"
#     else
#         set -x PATH $HOME/miniforge3/bin $PATH
#     end
# end
#
# if test -f "$HOME/miniforge3/etc/fish/conf.d/mamba.fish"
#     source "$HOME/miniforge3/etc/fish/conf.d/mamba.fish"
# end
# <<< conda initialize <<<
