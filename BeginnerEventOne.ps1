<#
Dr. Scripto is in a tizzy! It seems that someone has allowed a series of
application log files to pile up for around two years, and they’re
starting to put the pinch on free disk space on a server. Your job is to
help get the old files off to a new location. 

The log files are located in C:\Application\Log. There are three
applications that write logs here, and each uses its own subfolder. For
example, C:\Application\Log\App1, C:\Application\Log\OtherApp, and
C:\Application\Log\ThisAppAlso. Within those subfolders, the filenames
are random GUIDs with a .LOG filename extension. Once created on disk,
the files are never touched again by the applications. 

Your goal is to grab all of the files older than 90 days and move them
to \\NASServer\Archives. You need to maintain the subfolder structure,
so that files from C:\Application\Log\App1 get moved to
\\NASServer\Archives\App1, and so forth. 

You want to ensure that any errors that happen during the move are
clearly displayed to whoever is running your command. You also want your
command to be as concise as possible – Dr. Scripto says a one-liner
would be awesome, if you can pull it off, but it’s not mandatory that
your command be that concise. It’s also okay to use full command and
parameter names. If no errors occur, your command doesn’t need to
display any output – “no news is good news.”
#>

# -------------------------------------
# Beginner Event 1 - Solution Submitted
# Processes all sub directories of C:\Application\Log
# Requires PowerShell 3

Get-ChildItem -Directory -Path 'C:\Application\Log' |
    ForEach-Object {
        $destDir = Join-Path -Path '\\NASServer\Archives' -ChildPath $PSItem.Name
        If (!(Test-Path $destDir)) { mkdir $destDir }
        Get-ChildItem -File -Filter *.log -Path $PSItem.FullName |
        Where-Object { $PSItem.LastWriteTime -lt (Get-Date).Date.AddDays(-90) } |
        Move-Item -Destination $destDir
    }
# -------------------------------------
