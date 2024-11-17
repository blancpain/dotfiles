# Starship setup
def --env setup_starship [] {
  if not ($env.HOME | path join ".cache" "starship" | path exists) {
    mkdir ($env.HOME | path join ".cache" "starship")
  }
  if (which starship | is-empty) {
    echo "Starship not found in PATH"
    return
  }
  starship init nu | save -f ~/.cache/starship/init.nu
}


# NOTE: not sure if we need zoxide here if managed by brew
#zoxide
# zoxide init nushell | save -f ~/.zoxide.nu


# Carapace setup
def --env setup_carapace [] {
  if not ($env.HOME | path join ".cache" "carapace" | path exists) {
    mkdir ($env.HOME | path join ".cache" "carapace")
  }
  if (which carapace | is-empty) {
    echo "Carapace not found in PATH"
    return
  }
  $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
  carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
}

# FNM setup
def --env setup_fnm [] {
  if (which fnm | is-empty) {
    echo "FNM not found in PATH"
    return
  }
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
}

# Run setups
setup_starship
setup_carapace
setup_fnm

# Configure prompt
$env.STARSHIP_CONFIG = ($env.HOME | path join ".config" "starship" "starship.toml")
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }
