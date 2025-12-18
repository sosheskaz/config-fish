function fish_greeting
  set -l fortune_cmd "$(command -v fortune)"
  if test -z "$fortune_cmd"; return; end

  set -l cowfile "$(random choice daemon dragon eyes fox stegosaurus sus turtle)"

  command $fortune_cmd | cowsay -f "$cowfile" | lolcat
end
