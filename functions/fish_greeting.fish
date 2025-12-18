function fish_greeting
  set -f fortune_cmd "$(command -v fortune || command -v fortune_gem)"
  if test -z "$fortune_cmd"; return; end

  begin
    set -l cowsay_all_choices daemon dragon eyes fox stegosaurus sus turtle
    set -l avail_cows (string split ' ' (command cowsay -l | tail -n +2))
    for cow in $cowsay_all_choices
      if contains -- $cow $avail_cows
        set -fa cows $cow
      else
      end
    end
  end

  set -f cowfile "$(random choice $cows)"

  command $fortune_cmd | cowsay -f "$cowfile" | lolcat
end
