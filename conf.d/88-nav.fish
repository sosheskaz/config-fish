# zoxide — frecency-based cd replacement
# --cmd cd intercepts 'cd' directly; 'zi' opens interactive selection
if command -v zoxide >/dev/null
    zoxide init fish --cmd cd | source
end

# fzf — fuzzy finder keybindings only
# Ctrl+R: history search, Ctrl+T: file picker, Alt+C: cd into subdir
if command -v fzf >/dev/null
    fzf --fish | source
    set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border'
end
