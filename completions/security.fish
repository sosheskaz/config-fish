# security.fish - Completions for the macOS 'security' command
# Generated based on the macOS security(1) man page.

# -----------------------------------------------------------------------------
# Base Setup & Helpers
# -----------------------------------------------------------------------------

# Disable file completions by default.
# The security command is subcommand-heavy, and few arguments take raw files.
# We will explicitly enable file completion for specific commands (import, add-certificates).
complete -c security -f

# Helper: All top-level subcommands
# Used to determine if we are currently looking for a subcommand or an option
set -l all_commands \
    help list-keychains default-keychain login-keychain create-keychain \
    delete-keychain lock-keychain unlock-keychain set-keychain-settings \
    set-keychain-password show-keychain-info dump-keychain create-keypair \
    add-generic-password add-internet-password add-certificates \
    find-generic-password delete-generic-password find-internet-password \
    delete-internet-password find-key set-key-partition-list \
    find-certificate find-identity delete-certificate delete-identity \
    set-identity-preference get-identity-preference create-db export import \
    cms install-mds add-trusted-cert remove-trusted-cert dump-trust-settings \
    user-trust-settings-enable trust-settings-export trust-settings-import \
    verify-cert authorize authorizationdb execute-with-privileges leaks \
    smartcards list-smartcards export-smartcard error

# Helper function: Check if we haven't seen a subcommand yet
function __fish_security_no_subcommand
    set -l cmd (commandline -opc)
    if test (count $cmd) -eq 1
        return 0
    end
    for c in $cmd[2..-1]
        if contains -- $c $all_commands
            return 1
        end
    end
    return 0
end

# Helper function: List available keychains in standard locations
function __fish_security_list_keychains
    # List actual files in user and system keychain directories
    # Prioritizing speed over parsing the 'list-keychains' command output
    for dir in ~/Library/Keychains /Library/Keychains /System/Library/Keychains
        if test -d $dir
            find $dir -maxdepth 1 \( -name "*.keychain-db" -o -name "*.keychain" \) 2>/dev/null
        end
    end
end

# -----------------------------------------------------------------------------
# Global Options
# -----------------------------------------------------------------------------

# These can typically appear before subcommands
complete -c security -n "__fish_security_no_subcommand" -s h -d "Show usage for command"
complete -c security -n "__fish_security_no_subcommand" -s i -d "Run in interactive mode"
complete -c security -n "__fish_security_no_subcommand" -s l -d "Run /usr/bin/leaks on process before exit"
complete -c security -n "__fish_security_no_subcommand" -s p -r -d "Interactive mode with custom prompt"
complete -c security -n "__fish_security_no_subcommand" -s q -d "Less verbose"
complete -c security -n "__fish_security_no_subcommand" -s v -d "More verbose"

# -----------------------------------------------------------------------------
# Keychain Management Commands
# -----------------------------------------------------------------------------

# Common domain arguments
set -l domains user system common dynamic

# list-keychains
complete -c security -n "__fish_security_no_subcommand" -a list-keychains -d "Display or manipulate keychain search list"
complete -c security -n "__fish_seen_subcommand_from list-keychains" -s d -x -a "$domains" -d "Use preference domain"
complete -c security -n "__fish_seen_subcommand_from list-keychains" -s s -d "Set search list to specified keychains"

# default-keychain
complete -c security -n "__fish_security_no_subcommand" -a default-keychain -d "Display or set the default keychain"
complete -c security -n "__fish_seen_subcommand_from default-keychain" -s d -x -a "$domains" -d "Use preference domain"
complete -c security -n "__fish_seen_subcommand_from default-keychain" -s s -a "(__fish_security_list_keychains)" -d "Set default keychain"

# login-keychain
complete -c security -n "__fish_security_no_subcommand" -a login-keychain -d "Display or set the login keychain"
complete -c security -n "__fish_seen_subcommand_from login-keychain" -s d -x -a "$domains" -d "Use preference domain"
complete -c security -n "__fish_seen_subcommand_from login-keychain" -s s -a "(__fish_security_list_keychains)" -d "Set login keychain"

# create-keychain
complete -c security -n "__fish_security_no_subcommand" -a create-keychain -d "Create keychains"
complete -c security -n "__fish_seen_subcommand_from create-keychain" -s P -d "Prompt for password via SecurityAgent"
complete -c security -n "__fish_seen_subcommand_from create-keychain" -s p -x -d "Use specific password (insecure)"

# delete-keychain
complete -c security -n "__fish_security_no_subcommand" -a delete-keychain -d "Delete keychains"
complete -c security -n "__fish_seen_subcommand_from delete-keychain" -a "(__fish_security_list_keychains)"

# lock-keychain / unlock-keychain
complete -c security -n "__fish_security_no_subcommand" -a lock-keychain -d "Lock specified keychain"
complete -c security -n "__fish_seen_subcommand_from lock-keychain" -s a -d "Lock all keychains"
complete -c security -n "__fish_seen_subcommand_from lock-keychain" -a "(__fish_security_list_keychains)"

complete -c security -n "__fish_security_no_subcommand" -a unlock-keychain -d "Unlock specified keychain"
complete -c security -n "__fish_seen_subcommand_from unlock-keychain" -s u -d "Do not lock on sleep"
complete -c security -n "__fish_seen_subcommand_from unlock-keychain" -s p -x -d "Keychain password"
complete -c security -n "__fish_seen_subcommand_from unlock-keychain" -a "(__fish_security_list_keychains)"

# set-keychain-settings
complete -c security -n "__fish_security_no_subcommand" -a set-keychain-settings -d "Set settings for keychain"
complete -c security -n "__fish_seen_subcommand_from set-keychain-settings" -s l -d "Lock when system sleeps"
complete -c security -n "__fish_seen_subcommand_from set-keychain-settings" -s u -d "Lock after timeout"
complete -c security -n "__fish_seen_subcommand_from set-keychain-settings" -s t -x -d "Timeout in seconds"

# show-keychain-info
complete -c security -n "__fish_security_no_subcommand" -a show-keychain-info -d "Show settings for keychain"
complete -c security -n "__fish_seen_subcommand_from show-keychain-info" -a "(__fish_security_list_keychains)"

# dump-keychain
complete -c security -n "__fish_security_no_subcommand" -a dump-keychain -d "Dump contents of keychain"
complete -c security -n "__fish_seen_subcommand_from dump-keychain" -s a -d "Dump access control list"
complete -c security -n "__fish_seen_subcommand_from dump-keychain" -s d -d "Dump decrypted data"
complete -c security -n "__fish_seen_subcommand_from dump-keychain" -s i -d "Interactive ACL editing"
complete -c security -n "__fish_seen_subcommand_from dump-keychain" -s r -d "Dump raw encrypted data"

# -----------------------------------------------------------------------------
# Keys & Passwords (Items)
# -----------------------------------------------------------------------------

# add-generic-password / add-internet-password
complete -c security -n "__fish_security_no_subcommand" -a "add-generic-password" -d "Add generic password item"
complete -c security -n "__fish_security_no_subcommand" -a "add-internet-password" -d "Add internet password item"

# Shared flags for add-password commands
for cmd in add-generic-password add-internet-password
    complete -c security -n "__fish_seen_subcommand_from $cmd" -s a -x -d "Account name"
    complete -c security -n "__fish_seen_subcommand_from $cmd" -s c -x -d "Creator code"
    complete -c security -n "__fish_seen_subcommand_from $cmd" -s C -x -d "Type code"
    complete -c security -n "__fish_seen_subcommand_from $cmd" -s D -x -d "Kind"
    complete -c security -n "__fish_seen_subcommand_from $cmd" -s j -x -d "Comment"
    complete -c security -n "__fish_seen_subcommand_from $cmd" -s l -x -d "Label"
    complete -c security -n "__fish_seen_subcommand_from $cmd" -s w -x -d "Password string"
    complete -c security -n "__fish_seen_subcommand_from $cmd" -s A -d "Allow all apps access (Insecure)"
    complete -c security -n "__fish_seen_subcommand_from $cmd" -s T -r -d "Allow specific app path"
    complete -c security -n "__fish_seen_subcommand_from $cmd" -s U -d "Update if exists"
end

# Specific to add-internet-password
complete -c security -n "__fish_seen_subcommand_from add-internet-password" -s s -x -d "Server name"
complete -c security -n "__fish_seen_subcommand_from add-internet-password" -s r -x -d "Protocol (http, ftp, etc)"
complete -c security -n "__fish_seen_subcommand_from add-internet-password" -s P -x -d "Port"

# Specific to add-generic-password
complete -c security -n "__fish_seen_subcommand_from add-generic-password" -s s -x -d "Service name"
complete -c security -n "__fish_seen_subcommand_from add-generic-password" -s G -x -d "Generic attribute value"

# find-generic-password / find-internet-password
complete -c security -n "__fish_security_no_subcommand" -a find-generic-password -d "Find generic password item"
complete -c security -n "__fish_security_no_subcommand" -a find-internet-password -d "Find internet password item"

for cmd in find-generic-password find-internet-password
    complete -c security -n "__fish_seen_subcommand_from $cmd" -s a -x -d "Match account"
    complete -c security -n "__fish_seen_subcommand_from $cmd" -s s -x -d "Match service/server"
    complete -c security -n "__fish_seen_subcommand_from $cmd" -s l -x -d "Match label"
    complete -c security -n "__fish_seen_subcommand_from $cmd" -s g -d "Display password for item"
end

# -----------------------------------------------------------------------------
# Certificates & Identities
# -----------------------------------------------------------------------------

# find-identity
complete -c security -n "__fish_security_no_subcommand" -a find-identity -d "Find identity (cert + private key)"
complete -c security -n "__fish_seen_subcommand_from find-identity" -s v -d "Show valid identities only"
complete -c security -n "__fish_seen_subcommand_from find-identity" -s p -x -a "basic ssl-client ssl-server smime eap ipsec ichat codesigning sys-default sys-kerberos-kdc" -d "Policy"
complete -c security -n "__fish_seen_subcommand_from find-identity" -s s -x -d "Policy string (e.g. hostname)"

# find-certificate
complete -c security -n "__fish_security_no_subcommand" -a find-certificate -d "Find certificate item"
complete -c security -n "__fish_seen_subcommand_from find-certificate" -s a -d "Find all matching"
complete -c security -n "__fish_seen_subcommand_from find-certificate" -s c -x -d "Match name"
complete -c security -n "__fish_seen_subcommand_from find-certificate" -s e -x -d "Match email"
complete -c security -n "__fish_seen_subcommand_from find-certificate" -s p -d "Output PEM"
complete -c security -n "__fish_seen_subcommand_from find-certificate" -s Z -d "Print SHA-256 hash"

# add-certificates
complete -c security -n "__fish_security_no_subcommand" -a add-certificates -d "Add certificates to keychain"
complete -c security -n "__fish_seen_subcommand_from add-certificates" -s k -a "(__fish_security_list_keychains)" -d "Target keychain"
# Allow file completion for add-certificates (PEM/DER files)
complete -c security -n "__fish_seen_subcommand_from add-certificates" --force-files

# verify-cert
complete -c security -n "__fish_security_no_subcommand" -a verify-cert -d "Verify one or more certificates"
complete -c security -n "__fish_seen_subcommand_from verify-cert" -s c -r --force-files -d "Cert file (DER/PEM)"
complete -c security -n "__fish_seen_subcommand_from verify-cert" -s r -r --force-files -d "Root cert file"
complete -c security -n "__fish_seen_subcommand_from verify-cert" -s p -x -a "ssl smime codeSign IPSec basic swUpdate pkgSign eap appleID macappstore timestamping" -d "Policy"
complete -c security -n "__fish_seen_subcommand_from verify-cert" -s n -x -d "Name to verify (hostname/email)"
complete -c security -n "__fish_seen_subcommand_from verify-cert" -s L -d "Local certs only (no network)"
complete -c security -n "__fish_seen_subcommand_from verify-cert" -s v -d "Verbose trust results"

# -----------------------------------------------------------------------------
# Import / Export
# -----------------------------------------------------------------------------

# export
set -l export_types certs allKeys pubKeys privKeys identities all
set -l export_formats openssl bsafe pkcs7 pkcs8 pkcs12 x509 openssh1 openssh2 pemseq

complete -c security -n "__fish_security_no_subcommand" -a export -d "Export items from keychain"
complete -c security -n "__fish_seen_subcommand_from export" -s k -a "(__fish_security_list_keychains)" -d "Source keychain"
complete -c security -n "__fish_seen_subcommand_from export" -s t -x -a "$export_types" -d "Type of items"
complete -c security -n "__fish_seen_subcommand_from export" -s f -x -a "$export_formats" -d "Format"
complete -c security -n "__fish_seen_subcommand_from export" -s o -r --force-files -d "Output file"
complete -c security -n "__fish_seen_subcommand_from export" -s w -d "Wrap private keys"
complete -c security -n "__fish_seen_subcommand_from export" -s p -d "PEM armour"

# import
set -l import_types cert pub priv session agg
set -l import_formats openssl bsafe raw pkcs7 pkcs8 pkcs12 x509 openssh1 openssh2 pemseq

complete -c security -n "__fish_security_no_subcommand" -a import -d "Import items into keychain"
# Enable file completion for the first argument of import (the input file)
complete -c security -n "__fish_seen_subcommand_from import" --force-files
complete -c security -n "__fish_seen_subcommand_from import" -s k -a "(__fish_security_list_keychains)" -d "Target keychain"
complete -c security -n "__fish_seen_subcommand_from import" -s t -x -a "$import_types" -d "Type of items"
complete -c security -n "__fish_seen_subcommand_from import" -s f -x -a "$import_formats" -d "Format"
complete -c security -n "__fish_seen_subcommand_from import" -s A -d "Allow all apps access"
complete -c security -n "__fish_seen_subcommand_from import" -s x -d "Private keys non-extractable"

# -----------------------------------------------------------------------------
# Trust Settings
# -----------------------------------------------------------------------------

complete -c security -n "__fish_security_no_subcommand" -a dump-trust-settings -d "Display Trust Settings"
complete -c security -n "__fish_seen_subcommand_from dump-trust-settings" -s s -d "System certs"
complete -c security -n "__fish_seen_subcommand_from dump-trust-settings" -s d -d "Admin certs"

complete -c security -n "__fish_security_no_subcommand" -a add-trusted-cert -d "Add trusted certificate"
complete -c security -n "__fish_seen_subcommand_from add-trusted-cert" --force-files
complete -c security -n "__fish_seen_subcommand_from add-trusted-cert" -s d -d "Add to admin store"
complete -c security -n "__fish_seen_subcommand_from add-trusted-cert" -s r -x -a "trustRoot trustAsRoot deny unspecified" -d "Result type"

# -----------------------------------------------------------------------------
# Authorization & Smartcards
# -----------------------------------------------------------------------------

# authorizationdb
complete -c security -n "__fish_security_no_subcommand" -a authorizationdb -d "Read/Modify auth policy database"
complete -c security -n "__fish_seen_subcommand_from authorizationdb" -a "read write remove"

# smartcards
complete -c security -n "__fish_security_no_subcommand" -a smartcards -d "Smartcard token management"
complete -c security -n "__fish_seen_subcommand_from smartcards" -a "token" -d "Token management"
complete -c security -n "__fish_seen_subcommand_from smartcards" -s l -d "List disabled tokens"

# list-smartcards
complete -c security -n "__fish_security_no_subcommand" -a list-smartcards -d "Display ids of available smartcards"

# error
complete -c security -n "__fish_security_no_subcommand" -a error -d "Display error string for code"

# leaks
complete -c security -n "__fish_security_no_subcommand" -a leaks -d "Run /usr/bin/leaks on process"
