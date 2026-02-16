function ding --description 'Send a macOS notification (click to focus tab in iTerm2)'
  set -l message "Done"
  if test (count $argv) -gt 0
    set message "$argv"
  end

  if test "$TERM_PROGRAM" = iTerm.app
    printf '\e]9;%s\a' "$message"
  else
    printf '\a'
  end
end
