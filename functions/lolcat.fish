function lolcat
  set -q LOLCAT_CMD || set -l LOLCAT_CMD lolcat
  set -f lolcat_cmd "$(command -v $LOLCAT_CMD)"
  if test -z "$lolcat_cmd"
    cat
    return
  end
  set -f lolcat_cmd $lolcat_cmd[1]

  if set -q $__fish_uname; set -f uname $__fish_uname
  else; set -f uname (uname); end

  switch $uname
    case 'FreeBSD'
      set -f truecolor_flag -b
    case '*'
      set -f truecolor_flag -t
  end

  if not contains -- $truecolor_flag $argv && test "$COLORTERM" = "truecolor" -o "$COLORTERM" = "24bit"
    set -a lolcat_cmd $truecolor_flag
  end

  command $lolcat_cmd $argv
end
