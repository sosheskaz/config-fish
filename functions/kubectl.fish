function kubectl
  set -q KUBECOLOR_CMD || set -l KUBECOLOR_CMD kubecolor
  set -l kc_cmd (command -v $KUBECOLOR_CMD)
  if test -z "$kc_cmd"
    command kubectl $argv
    return
  end

  command $kc_cmd $argv
end
