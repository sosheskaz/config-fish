function turnabout-unlock
  argparse \
    'J/jump=' \
    'j/autojump' \
    -- $argv || return 1

  set -f target_user root
  set -f target_host '192.168.134.2'
  set -q AUTOJUMP_HOST && set -f autojump_host $AUTOJUMP_HOST || set -f autojump_host '100.67.77.12'
  set -f known_hosts_file "$HOME/.ssh/dropbear_known_hosts"
  set -f known_hosts_policy accept-new

  set -f SSH_ARGS \
    -t \
    -o UserKnownHostsFile="$known_hosts_file" \
    -o StrictHostKeyChecking="$known_hosts_policy" \

  if set -q _flag_jump || set -q _flag_autojump
    set -l jump_host $autojump_host
    if set -q _flag_jump
      set jump_host $_flag_jump
    end

    if test -z $jump_host
      echo "Validation failure: jump mode enabled but jump_host was empty" >&2
      return 1
    end

    set -a SSH_ARGS -J $jump_host
  end

  ssh $SSH_ARGS \
    $target_user@$target_host \
    cryptroot-unlock
end

# 1. Completion for the flags themselves
# This makes -j and -J appear in the menu immediately
complete -c turnabout-unlock -a 'j/autojump' -d 'Use Tailscale IP instead of LAN'
complete -c turnabout-unlock -a 'J/jump=' -d 'Specify a custom jump host (IP or hostname)'
