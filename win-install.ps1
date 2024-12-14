Copy-Item -Recurse -Force @('.\.config\', '.\.gitconfig', '.\.tigrc') $env:USERPROFILE
Copy-Item '.\win\Microsoft.PowerShell_profile.ps1' $env:USERPROFILE\Documents\PowerShell\
