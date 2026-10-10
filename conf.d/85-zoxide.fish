if command -v zoxide >/dev/null
    # Older zoxide reads cd.fish from disk, but newer fish embeds it in the binary.
    if not functions --query __zoxide_cd_internal
        functions --copy cd __zoxide_cd_internal
    end
    zoxide init fish | source
end
