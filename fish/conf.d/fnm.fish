# Initialize fnm only when available. conf.d files run before config.fish sets up PATH
# so we also check the Nix system path directly.
set -l fnm_cmd fnm
if test -x /run/current-system/sw/bin/fnm
    set fnm_cmd /run/current-system/sw/bin/fnm
else if not type -q fnm
    exit
end

$fnm_cmd env --use-on-cd --shell fish | source
