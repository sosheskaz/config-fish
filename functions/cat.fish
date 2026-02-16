function cat
  set -q BAT_CMD || set -l BAT_CMD bat
  set -l bat_cmd (command -v $BAT_CMD)
  if test -z "$bat_cmd"
    command cat $argv
    return
  end

  command $bat_cmd --paging=never $argv
end
