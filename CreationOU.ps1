import-module C:\lib\FCT_MEF.ps1 -Force

# Import des utilisateurs et mise en forme des utilisateurs
$mesusers = import-csv -delimiter ";" -path C:\lib\Users.csv -Encoding oem
$mesusers = $mesusers | ForEach-Object {
    FCT_MEF-Edit-User -objuser $_ 
}

# Création des OU dans l'ADDS
$ldapdomainname = ($env:userdnsdomain.split(".") | Foreach-Object { "DC=$_" }) -join ','
$listeservices = ($mesusers | group service).name
$listeservices | foreach-object {
    try { New-ADOrganizationalUnit -Path "OU=_Services,$ldapdomainname" -Name $_ }
    catch { write-host "il y a eu une erreur" }
}