function lolcat
  set -q LOLCAT_CMD || set -l LOLCAT_CMD lolcat
  set -f lolcat_cmd "$(command -v $LOLCAT_CMD)"
  if test -z "$lolcat_cmd"
    cat
    return
  end
  set -f lolcat_cmd $lolcat_cmd[1]

  if not contains -- -t $argv && test "$COLORTERM" = "truecolor" -o "$COLORTERM" = "24bit"
    set -fa lolcat_cmd -t
  end

  command $lolcat_cmd $argv
end
