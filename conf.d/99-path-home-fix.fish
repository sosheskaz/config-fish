# Replace any literal '~' in PATH entries with $HOME.
# macOS /etc/paths.d/ files (e.g., dotnet-cli-tools) can contain unexpanded
# tildes, which breaks path resolution in non-interactive contexts.

for _varname in PATH fish_user_paths
    set -l cleaned
    for p in $$_varname
        set -a cleaned (string replace '~' "$HOME" -- $p)
    end
    set -g $_varname $cleaned
end
