function figlet
  set -q FIGLET_CMD || set -l FIGLET_CMD figlet
  set -f figlet_cmd "$(command -v $FIGLET_CMD)"
  if test -z "$figlet_cmd"
    cat
    return
  end
  set -f figlet_cmd $figlet_cmd[1]

  if not contains -- -w $argv and set -q COLUMNS
    set -fa figlet_cmd -w "$COLUMNS"
  end

  command $figlet_cmd $argv
end
