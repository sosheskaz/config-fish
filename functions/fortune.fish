function fortune
  set -q FORTUNE_CMD || set -l FORTUNE_CMD fortune fortune_gem
  set -f fortune_cmd $(command -v $FORTUNE_CMD) || return $status
  set -f fortune_cmd $fortune_cmd[1]

  command "$fortune_cmd" $argv
end
