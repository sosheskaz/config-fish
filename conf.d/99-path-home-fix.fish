# Replace any literal '~' in PATH entries with $HOME.
# Some tools (e.g., dotnet) add paths with unexpanded tildes,
# which breaks path resolution in non-interactive contexts.

set -l cleaned
for p in $PATH
    set -a cleaned (string replace '~' "$HOME" -- $p)
end
set -gx PATH $cleaned