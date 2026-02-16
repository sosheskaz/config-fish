function _bw_parse_session --description "Extract BW_SESSION token from bw unlock output"
    # Expects output lines as arguments (from captured command output)
    set -l output $argv

    # Try: export BW_SESSION="..."
    set -l token (printf '%s\n' $output | string match -r 'export BW_SESSION="([^"]+)"')[2]
    if test -n "$token"
        echo $token
        return 0
    end

    # Try: BW_SESSION="..."
    set token (printf '%s\n' $output | string match -r 'BW_SESSION="([^"]+)"')[2]
    if test -n "$token"
        echo $token
        return 0
    end

    return 1
end
