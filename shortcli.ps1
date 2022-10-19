<#
.DESCRIPTION
Script adds a bit of code to your powershell profile to shorten visible CLI line from c:\xx\xx\xxx\yy\ to just yy\
Version: 1.0.0
Last revision date: 2022-10-19
Prerequisites: needs an elevated (Run as administrator) powershell session.
Usage: just run the file on elevated powershell session.
#>
Write-Host -ForegroundColor DarkYellow " ____  _   _  ___  ____ _____    ____ _     ___ "
Write-Host -ForegroundColor DarkYellow "/ ___|| | | |/ _ \|  _ \_   _|  / ___| |   |_ _|"
Write-Host -ForegroundColor DarkYellow "\___ \| |_| | | | | |_) || |   | |   | |    | | "
Write-Host -ForegroundColor DarkYellow " ___) |  _  | |_| |  _ < | |   | |___| |___ | | "
Write-Host -ForegroundColor DarkYellow "|____/|_| |_|\___/|_| \_\|_|    \____|_____|___|"

$getPol = Get-ExecutionPolicy
$elevatedCLI = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

#checks execution policy
if($elevatedCLI -eq $true){
    if($getPol -ne "RemoteSigned"){
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
        Write-Host -ForegroundColor DarkGray "Execution policy set to 'RemoteSigned'"
    }
}else{
    Write-Host -ForegroundColor DarkMagenta "Please run the script on elevated powershell session (As Administrator)"
    Break
}

#checks if a profile is set up
if (!(test-path $profile)){
    #if no profile (result $false) then creates one
    new-item -path $profile -itemtype file -force
    Set-Content -Path $profile -Value '
    function prompt {
      $p = Split-Path -leaf -path (Get-Location)
      "$p> "
    }
    '
    Write-Host -ForegroundColor DarkYellow "You might need to restart vscode to get a short cli path or just new terminal could work"
}else{
    $readCont = Get-Content -path $profile
    if($readCont -like "*function prompt*"){
        Write-Host -ForegroundColor DarkMagenta 'Code is alread applied to $profile. Exiting.'
        Break
    }else{
        Add-Content -Path $profile -Value '
        function prompt {
            $p = Split-Path -leaf -path (Get-Location)
            "$p> "
        }
        '
        Write-Host -ForegroundColor DarkYellow '$profile path has been found. Code has been added. Try new terminal or restart vscode/windows terminal'
    }
}

#code taken from:
#https://stackoverflow.com/questions/52107170/hiding-the-full-file-path-in-a-powershell-command-prompt-in-vscode/52107556#52107556