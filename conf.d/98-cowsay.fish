function cowsay
  set -l cowsay_cmd "$(command -v cowsay)"
  if test $status != 0
    command cat
    return
  end

  set -l cowcols "$(math $COLUMNS - 4)"
  set -la cowsay_cmd -W "$cowcols"

  $cowsay_cmd $argv
end
