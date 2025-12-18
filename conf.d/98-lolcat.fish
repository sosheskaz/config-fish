function lolcat
  set -l lolcat_cmd "$(command -v lolcat)"
  if test $status = 0
    if test "$COLORTERM" = "truecolor" -o "$COLORTERM" = "24bit"
      set -la lolcat_cmd -t
    end
  else
    set -l lolcat_cmd "$(command -v cat)"
  end

  command $lolcat_cmd $argv
end
