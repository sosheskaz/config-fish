# tmutil.fish - Completions for macOS Time Machine utility

# --- Helper Functions ---

# Helper to detect if we are strictly at the top level (no subcommand selected yet)
function __fish_tmutil_needs_command
    set -l cmd (commandline -opc)
    if test (count $cmd) -eq 1
        return 0
    end
    return 1
end

# Helper to get backup Destination IDs and Names for autocompletion
# format: ID \t Name
function __fish_tmutil_destination_ids
    # destinationinfo output is structured like:
    # Name          : DiskName
    # ...
    # ID            : 1234-5678...
    command tmutil destinationinfo 2>/dev/null | awk -F': ' '
        /Name/ { name=$2 }
        /ID/ { if (name) print $2 "\t" name; else print $2 }
    '
end

# List of all subcommands for reference and validation
set -l tm_commands setdestination destinationinfo setquota removedestination \
    addexclusion removeexclusion isexcluded enable disable startbackup stopbackup \
    compare verifychecksums restore delete deleteinprogress latestbackup listbackups \
    machinedirectory calculatedrift uniquesize inheritbackup associatedisk \
    localsnapshot listlocalsnapshots listlocalsnapshotdates deletelocalsnapshots \
    thinlocalsnapshots

# Disable file completion by default, enable it specifically for commands that need it
complete -c tmutil -f

# --- VERB DEFINITIONS ---

# 1. Configuration & Destinations

# setdestination
complete -c tmutil -n __fish_tmutil_needs_command -a setdestination -d "Configure a backup destination"
complete -c tmutil -n "__fish_seen_subcommand_from setdestination" -s a -d "Add to list instead of replacing"
complete -c tmutil -n "__fish_seen_subcommand_from setdestination" -s p -d "Enter password at prompt (for AFP/SMB)"
complete -c tmutil -n "__fish_seen_subcommand_from setdestination" -a "(__fish_complete_directories)" -d "Mount point or URL"

# destinationinfo
complete -c tmutil -n __fish_tmutil_needs_command -a destinationinfo -d "Print information about configured destinations"
complete -c tmutil -n "__fish_seen_subcommand_from destinationinfo" -s X -d "Output in XML property list format"

# setquota
complete -c tmutil -n __fish_tmutil_needs_command -a setquota -d "Set quota for a specific destination"
complete -c tmutil -n "__fish_seen_subcommand_from setquota" -a "(__fish_tmutil_destination_ids)" -d "Destination ID"

# removedestination
complete -c tmutil -n __fish_tmutil_needs_command -a removedestination -d "Remove a destination configuration"
complete -c tmutil -n "__fish_seen_subcommand_from removedestination" -a "(__fish_tmutil_destination_ids)" -d "Destination ID"

# 2. Exclusions

# addexclusion
complete -c tmutil -n __fish_tmutil_needs_command -a addexclusion -d "Exclude item from backups"
complete -c tmutil -n "__fish_seen_subcommand_from addexclusion" -F # Allow files
complete -c tmutil -n "__fish_seen_subcommand_from addexclusion" -s p -d "Fixed-path exclusion"
complete -c tmutil -n "__fish_seen_subcommand_from addexclusion" -s v -d "Volume exclusion"

# removeexclusion
complete -c tmutil -n __fish_tmutil_needs_command -a removeexclusion -d "Remove an exclusion"
complete -c tmutil -n "__fish_seen_subcommand_from removeexclusion" -F # Allow files
complete -c tmutil -n "__fish_seen_subcommand_from removeexclusion" -s p -d "Fixed-path exclusion"
complete -c tmutil -n "__fish_seen_subcommand_from removeexclusion" -s v -d "Volume exclusion"

# isexcluded
complete -c tmutil -n __fish_tmutil_needs_command -a isexcluded -d "Check if an item is excluded"
complete -c tmutil -n "__fish_seen_subcommand_from isexcluded" -F # Allow files
complete -c tmutil -n "__fish_seen_subcommand_from isexcluded" -s X -d "Output in XML property list format"

# 3. Control

# enable/disable
complete -c tmutil -n __fish_tmutil_needs_command -a enable -d "Turn on automatic backups"
complete -c tmutil -n __fish_tmutil_needs_command -a disable -d "Turn off automatic backups"

# startbackup
complete -c tmutil -n __fish_tmutil_needs_command -a startbackup -d "Begin a backup (+opts)"
complete -c tmutil -n "__fish_seen_subcommand_from startbackup" -s a -l auto -d "Run in system-scheduled mode"
complete -c tmutil -n "__fish_seen_subcommand_from startbackup" -s b -l block -d "Wait until finished before exiting"
complete -c tmutil -n "__fish_seen_subcommand_from startbackup" -s r -l rotation -d "Allow destination rotation"
complete -c tmutil -n "__fish_seen_subcommand_from startbackup" -s d -l destination -x -a "(__fish_tmutil_destination_ids)" -d "Specific destination ID"

# stopbackup
complete -c tmutil -n __fish_tmutil_needs_command -a stopbackup -d "Cancel backup in progress"

# 4. Inspection & Manipulation

# compare
complete -c tmutil -n __fish_tmutil_needs_command -a compare -d "Perform a backup diff"
complete -c tmutil -n "__fish_seen_subcommand_from compare" -F # Allow files
complete -c tmutil -n "__fish_seen_subcommand_from compare" -s a -d "Compare all metadata"
complete -c tmutil -n "__fish_seen_subcommand_from compare" -s n -d "No metadata comparison"
complete -c tmutil -n "__fish_seen_subcommand_from compare" -s @ -d "Compare extended attributes"
complete -c tmutil -n "__fish_seen_subcommand_from compare" -s c -d "Compare creation times"
complete -c tmutil -n "__fish_seen_subcommand_from compare" -s d -d "Compare file data forks"
complete -c tmutil -n "__fish_seen_subcommand_from compare" -s e -d "Compare ACLs"
complete -c tmutil -n "__fish_seen_subcommand_from compare" -s f -d "Compare file flags"
complete -c tmutil -n "__fish_seen_subcommand_from compare" -s g -d "Compare GIDs"
complete -c tmutil -n "__fish_seen_subcommand_from compare" -s m -d "Compare file modes"
complete -c tmutil -n "__fish_seen_subcommand_from compare" -s s -d "Compare sizes"
complete -c tmutil -n "__fish_seen_subcommand_from compare" -s t -d "Compare modification times"
complete -c tmutil -n "__fish_seen_subcommand_from compare" -s u -d "Compare UIDs"
complete -c tmutil -n "__fish_seen_subcommand_from compare" -s D -r -d "Limit traversal depth"
complete -c tmutil -n "__fish_seen_subcommand_from compare" -s E -d "Ignore exclusions"
complete -c tmutil -n "__fish_seen_subcommand_from compare" -s I -r -d "Ignore paths with name"
complete -c tmutil -n "__fish_seen_subcommand_from compare" -s U -d "Ignore logical volume identity"
complete -c tmutil -n "__fish_seen_subcommand_from compare" -s X -d "Output in XML property list format"

# verifychecksums
complete -c tmutil -n __fish_tmutil_needs_command -a verifychecksums -d "Compute and verify checksums in backup"
complete -c tmutil -n "__fish_seen_subcommand_from verifychecksums" -F

# restore
complete -c tmutil -n __fish_tmutil_needs_command -a restore -d "Restore item from backup"
complete -c tmutil -n "__fish_seen_subcommand_from restore" -s v -d "Verbose mode"
complete -c tmutil -n "__fish_seen_subcommand_from restore" -F

# delete
complete -c tmutil -n __fish_tmutil_needs_command -a delete -d "Delete specific backups"
complete -c tmutil -n "__fish_seen_subcommand_from delete" -s d -r -a "(__fish_complete_directories)" -d "Backup mount point"
complete -c tmutil -n "__fish_seen_subcommand_from delete" -s t -r -d "Timestamp (YYYY-MM-DD-HHMMSS)"
complete -c tmutil -n "__fish_seen_subcommand_from delete" -s p -r -F -d "Specific path to delete (HFS only)"

# deleteinprogress
complete -c tmutil -n __fish_tmutil_needs_command -a deleteinprogress -d "Delete in-progress backups"
complete -c tmutil -n "__fish_seen_subcommand_from deleteinprogress" -F -d "Machine directory"

# latestbackup
complete -c tmutil -n __fish_tmutil_needs_command -a latestbackup -d "List latest completed backup"
complete -c tmutil -n "__fish_seen_subcommand_from latestbackup" -s d -r -a "(__fish_complete_directories)" -d "Backup mount point"
complete -c tmutil -n "__fish_seen_subcommand_from latestbackup" -s m -d "Attempt to mount and show path"
complete -c tmutil -n "__fish_seen_subcommand_from latestbackup" -s t -d "Show only timestamp"

# listbackups
complete -c tmutil -n __fish_tmutil_needs_command -a listbackups -d "List all completed backups"
complete -c tmutil -n "__fish_seen_subcommand_from listbackups" -s d -r -a "(__fish_complete_directories)" -d "Backup mount point"
complete -c tmutil -n "__fish_seen_subcommand_from listbackups" -s m -d "Attempt to mount and show paths"
complete -c tmutil -n "__fish_seen_subcommand_from listbackups" -s t -d "Show only timestamps"

# machinedirectory
complete -c tmutil -n __fish_tmutil_needs_command -a machinedirectory -d "Print path to current machine directory"

# calculatedrift
complete -c tmutil -n __fish_tmutil_needs_command -a calculatedrift -d "Analyze change between backups"
complete -c tmutil -n "__fish_seen_subcommand_from calculatedrift" -F -d "Machine directory"

# uniquesize
complete -c tmutil -n __fish_tmutil_needs_command -a uniquesize -d "Determine unique size of backup path"
complete -c tmutil -n "__fish_seen_subcommand_from uniquesize" -F

# inheritbackup
complete -c tmutil -n __fish_tmutil_needs_command -a inheritbackup -d "Claim a machine directory or sparsebundle"
complete -c tmutil -n "__fish_seen_subcommand_from inheritbackup" -F

# associatedisk
complete -c tmutil -n __fish_tmutil_needs_command -a associatedisk -d "Bind volume store to local disk"
complete -c tmutil -n "__fish_seen_subcommand_from associatedisk" -s a -d "Find all matching volume stores"
complete -c tmutil -n "__fish_seen_subcommand_from associatedisk" -a "(__fish_complete_directories)" -d "Mount point or Snapshot Volume"

# 5. Local Snapshots

# localsnapshot
complete -c tmutil -n __fish_tmutil_needs_command -a localsnapshot -d "Create new local snapshots"

# listlocalsnapshots
complete -c tmutil -n __fish_tmutil_needs_command -a listlocalsnapshots -d "List local snapshots of volume"
complete -c tmutil -n "__fish_seen_subcommand_from listlocalsnapshots" -a "(__fish_complete_directories)" -d "Mount point"

# listlocalsnapshotdates
complete -c tmutil -n __fish_tmutil_needs_command -a listlocalsnapshotdates -d "List creation dates of local snapshots"
complete -c tmutil -n "__fish_seen_subcommand_from listlocalsnapshotdates" -a "(__fish_complete_directories)" -d "Mount point (Optional)"

# deletelocalsnapshots
complete -c tmutil -n __fish_tmutil_needs_command -a deletelocalsnapshots -d "Delete local snapshots"
complete -c tmutil -n "__fish_seen_subcommand_from deletelocalsnapshots" -a "(__fish_complete_directories)" -d "Mount Point"
# Note: Date completion is hard to predict, so we leave it empty/generic

# thinlocalsnapshots
complete -c tmutil -n __fish_tmutil_needs_command -a thinlocalsnapshots -d "ciThin local snapshots"
complete -c tmutil -n "__fish_seen_subcommand_from thinlocalsnapshots" -a "(__fish_complete_directories)" -d "Mount Point"
