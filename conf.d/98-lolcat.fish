function lolcat
  set -f lolcat_cmd "$(command -v lolcat)"
  if test $status = 0
    if test "$COLORTERM" = "truecolor" -o "$COLORTERM" = "24bit"
      set -fa lolcat_cmd -t
    end
  else
    set -f lolcat_cmd cat
  end

  command $lolcat_cmd $argv
end
