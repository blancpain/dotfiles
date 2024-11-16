#starship
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
#zoxide
zoxide init nushell | save -f ~/.zoxide.nu
#carapace
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# $env.PATH = ($env.PATH | prepend "/home/blancpain/.fnm")

load-env (fnm env --shell bash
    | lines
    | str replace 'export ' ''
    | str replace -a '"' ''
    | split column '='
    | rename name value
    | where name != "FNM_ARCH" and name != "PATH"
    | reduce -f {} {|it, acc| $acc | upsert $it.name $it.value }
)

$env.PATH = ($env.PATH
    | split row (char esep)
    | prepend $"($env.FNM_MULTISHELL_PATH)/bin"
)

# # FZF configurations
# $env.FZF_CTRL_R_OPTS = "--border-label=' Command History ' --prompt=' '"
# $env.FZF_DEFAULT_COMMAND = "fd -H -E '.git'"
# $env.FZF_DEFAULT_OPTS = "--reverse --no-info --prompt=' ' --pointer='' --marker='' --ansi --color gutter:-1,bg+:-1,header:4,separator:0,info:0,label:4,border:4,prompt:7,pointer:5,query:7,prompt:7"
# $env.FZF_TMUX_OPTS = "-p --no-info --ansi --color gutter:-1,bg+:-1,header:4,separator:0,info:0,label:4,border:4,prompt:7,pointer:5,query:7,prompt:7"
