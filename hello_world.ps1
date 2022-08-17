#!/usr/local/bin/pwsh-preview
Write-Warning -Message "Confirming PowerShell Preview working in Code context"
Write-Warning -Message   "Need multiple commands to check debugging"
$showThis="A variable that is expanded on output"
Write-Output ('Show variable showThis:{0}' -f $showThis)

# straight copy/paste from README.md page on github now works
"
number: 1
string: 'hello'
" | 
    ?<NewLine> -Split |     
    Foreach-Object {
        $key, $value  = $_ | ?<Colon> -Split -Count 1
        if ($key) {
            @{$key=$value}
        }
    }

# Get-Help Irregular outputs OLDER version that does not work
#
# To see all of the things you can do with any Regular Expression, run:

#     Get-Help Use-Regex -Full

# Matches are also decorated with information about the input and position.  This allows you to pipe one match into another search:

    "number: 1
    string: 'hello'" | ?<NewLine> -Split |  
        Foreach-Object {
            $key = $_ | ?<Colon> -Until -Trim -IncludeMatch
            $value = $key | ?<LineStartOrEnd> -Until -Trim
            @{$key.Trim(':')=$value}
        }
