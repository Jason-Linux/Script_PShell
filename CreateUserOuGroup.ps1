import-module C:\lib\FCT_MEF.ps1 -Force

#Etape 1 : Import des utilisateurs et mise en forme des utilisateurs
write-progress -Activity "1 / 5 Import des utilisateurs et mise en forme des utilisateurs" -PercentComplete (100 * 1 / 5) -id 1
$mesusers = import-csv -delimiter ";" -path C:\lib\Users.csv -Encoding oem
$mesusers = $mesusers | ForEach-Object {
    FCT_MEF-Edit-User -objuser $_ 
}

#Etape 2 : Création des OU dans l'ADDS
write-progress -Activity "2 / 5 : Création des OU dans l'ADDS" -PercentComplete (100 * 2 / 5) -id 1
$ldapdomainname = ($env:userdnsdomain.split(".") | Foreach-Object { "DC=$_" }) -join ','
$listeservices = ($mesusers | group service).name
New-ADOrganizationalUnit -name "_Services"
$listeservices | foreach-object {
    try { New-ADOrganizationalUnit -Path "OU=_Services,$ldapdomainname" -Name $_ }
    catch { write-host "il y a eu une erreur" }
}

#Etape 3 : Création des utilisateurs dans l'ADDS
write-progress -Activity "3 / 5 : Création des utilisateurs dans l'ADDS" -PercentComplete (100 * 3 / 5) -id 1
$mesusers | ForEach-Object { $cpt = 1 } {
    $pourcentage = 100 * ($cpt / $mesusers.count)
    write-progress -id 2 -activity "$cpt / $($mesusers.count) -> $($_.nomcomplet)" -PercentComplete $pourcentage
    
    new-aduser -name $_.idrh -path "OU=$($_.service),OU=_Services,$ldapdomainname" `
        -GivenName          $_.prenom  `
        -Surname            $_.nom `
        -Initials           $_.initiales `
        -Description        $_.trigramme `
        -department         $_.service `
        -title              $_.grade `
        -displayname        $_.nomcomplet `
        -EmailAddress       $_.email `
        -UserPrincipalName  $_.email `
        -AccountPassword   ($_.pass | ConvertTo-SecureString -AsPlainText -Force) `
        -enabled            $true  
    
    $cpt++
}

#Etape 4 : Créer les groupes GG_Service 
# et ajouter les utilisateurs dans leur groupe respectif
write-progress -Activity "4 / 5 : création des groupes GG" -PercentComplete (100 * 4 / 5) -id 1
$listeservices | foreach-object {
    new-adgroup -GroupScope Global -Name "GG_$_"
}

# Etape 5 : ajout des utilisateurs dans les groupes
write-progress -Activity "5 / 5 : Ajout des users dans les groupes GG" -PercentComplete (100 * 5 / 5) -id 1
$DPT = Get-aduser -filter * -Properties department | group department
$DPT | where name -ne "" | foreach-object {
    write-host "ajout des utilisateurs du service $($_.name)"
    Add-ADGroupMember "CN=GG_$($_.name),CN=Users,$ldapdomainname" -Members $_.group