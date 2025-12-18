if command -v asdf >/dev/null && not set -qx ASDF_DATA_DIR
  set -gx ASDF_DATA_DIR $HOME/.asdf
  fish_add_path "$ASDF_DATA_DIR/shims"
end
