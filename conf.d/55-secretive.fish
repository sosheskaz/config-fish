set -l secretive_sock "$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
if test -S "$secretive_sock"
    set -gx SSH_AUTH_SOCK $secretive_sock
end
