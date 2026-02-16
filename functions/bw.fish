# Bitwarden CLI wrapper — automatic session token management.
#
# bw is slow to start, so minimizing invocations matters. Decision logic:
#
# | Path                        | bw invocations | Notes                          |
# |-----------------------------|----------------|--------------------------------|
# | lock / logout               | 1              | Clear token + pass through     |
# | unlock                      | 1              | Capture token from output      |
# | Fast-path (--version, etc.) | 1              | No auth needed                 |
# | Has token, cmd succeeds     | 1              | Token injected via env         |
# | Has token, cmd fails,       | 3              | cmd + unlock + retry           |
# |   vault was locked          |                |                                |
# | Has token, cmd fails,       | 2              | cmd + unlock (fails fast)      |
# |   vault was NOT locked      |                |                                |
# | No token                    | 1              | Pass through directly          |
function bw --description "Bitwarden CLI wrapper with automatic session management"
    # Locate real bw command
    set -q BW_CMD || set -l BW_CMD bw
    set -l bw_cmd (command -v $BW_CMD)

    if test -z "$bw_cmd"
        echo "Error: Bitwarden CLI not found. Install with: brew install bitwarden-cli" >&2
        return 1
    end
    set bw_cmd $bw_cmd[1]

    # Determine subcommand
    set -l subcommand ""
    if test (count $argv) -gt 0
        set subcommand $argv[1]
    end

    switch $subcommand
        case logout lock
            set -e __bw_session
            command $bw_cmd $argv
            return $status

        case unlock
            set -l output (command $bw_cmd $argv)
            set -l exit_code $status

            if test $exit_code -eq 0
                set -l token (_bw_parse_session $output)
                if test -n "$token"
                    set -g __bw_session $token
                end
                echo $output
            end

            return $exit_code

        case '*'
            # Fast path: commands that don't need authentication
            if contains -- $subcommand --version --help -h -v login sync config serve
                command $bw_cmd $argv
                return $status
            end

            # If we have a cached token, use it directly — no extra bw calls
            if test -n "$__bw_session"
                env BW_SESSION="$__bw_session" command $bw_cmd $argv
                set -l exit_code $status

                # On success, we're done
                if test $exit_code -eq 0
                    return 0
                end

                # On failure, try re-unlocking — if the vault isn't actually
                # locked, unlock will fail and we return the original error
                set -e __bw_session
                echo "Command failed. Attempting re-unlock..." >&2
                set -l unlock_output (command $bw_cmd unlock)
                set -l unlock_code $status

                if test $unlock_code -ne 0
                    # Vault wasn't locked — original error stands
                    return $exit_code
                end

                set -l new_token (_bw_parse_session $unlock_output)
                if test -n "$new_token"
                    set -g __bw_session $new_token
                    env BW_SESSION="$new_token" command $bw_cmd $argv
                    return $status
                else
                    echo "Failed to extract session token" >&2
                    return 1
                end
            end

            # No token — pass through, let bw handle auth prompts
            command $bw_cmd $argv
            return $status
    end
end
