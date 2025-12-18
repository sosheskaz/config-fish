function cowsay
  set -q COWSAY_CMD || set -l COWSAY_CMD cowsay
  set -f cowsay_cmd "$(command -v $COWSAY_CMD)"
  if test -z "$cowsay_cmd"
    # fallback to cat if cowsay is not found
    cat
    return
  end
  set -f cowsay_cmd $cowsay_cmd[1]

  if not contains -- -W $argv && set -q COLUMNS
    set -fa cowsay_cmd -W "$(math $COLUMNS - 4)"
  end

  if not contains -- -f $argv
    set -l available_cowfiles (string split ' ' (_cachy -n cowsay_list -t 86400 -- "$cowsay_cmd[1]" -l | tail -n +2))
    set -l cowfile_choices
    if set -q COWFILES
      for cowfile in $COWFILES
        if contains -- $cowfile $available_cowfiles
          set -a cowfile_choices $cowfile
        end
      end
    else
      set -a cowfile_choices $available_cowfiles
    end
    if test (count $cowfile_choices) -gt 0
      # no valid cowfiles found, fallback to default behavior
      set -a cowsay_cmd -f (random choice $cowfile_choices)
    end
  end

  command $cowsay_cmd $argv
end
