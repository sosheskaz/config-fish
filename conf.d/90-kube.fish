begin
  if not set -qx KUBECTL_EXTERNAL_DIFF
    if set -l colordiff "$(command -v colordiff)"
      set -gx KUBECTL_EXTERNAL_DIFF "$colordiff"
    end
  end
end
