# Complete Codex profile names from the profile-v2 files in CODEX_HOME.
#
# Keep this in conf.d rather than completions/codex.fish so regenerating Codex's
# own completion script does not overwrite the local profile discovery layer.
function __codex_profile_names
    set -l codex_home "$CODEX_HOME"
    if test -z "$codex_home"
        set codex_home "$HOME/.codex"
    end

    for file in "$codex_home"/*.config.toml
        test -f "$file"; or continue

        set -l name (string replace -r '\.config\.toml$' '' -- (path basename -- "$file"))
        string match -rq '^[A-Za-z0-9_-]+$' -- "$name"; or continue
        printf '%s\tprofile config\n' "$name"
    end | sort -u
end

# Match the contexts where Codex currently accepts --profile. These predicates
# are defined by Codex's generated Fish completion script.
function __codex_profile_context
    functions -q __fish_codex_needs_command; or return 1
    functions -q __fish_codex_using_subcommand; or return 1

    # The generated parser cannot recognize an incomplete --profile value, so
    # use the command list to retain the top-level completion context here.
    set -l codex_subcommands exec e review login logout mcp plugin mcp-server app-server remote-control app completion update doctor sandbox debug execpolicy apply a resume archive delete unarchive fork cloud exec-server features help
    if not __fish_seen_subcommand_from $codex_subcommands
        return 0
    end

    __fish_codex_using_subcommand exec e
    and not __fish_seen_subcommand_from resume review help
end

complete -c codex \
    -n "__codex_profile_context" \
    -s p -l profile \
    -r -f \
    -a "(__codex_profile_names)"
