Import-Module c:\lib\FCT_MEF.ps1 -Force
$mesusers = import-csv -delimiter ";" -path C:\lib\Users.csv -Encoding oem
$mesusers = $mesusers | ForEach-Object { FCT_MEF-Edit-User -objuser $_ }


$ldapdomainname = ($env:userdnsdomain.split(".") | Foreach-Object { "DC=$_" }) -join ','
$mesusers | ForEach-Object { $cpt = 1 } {
    $pourcentage = 100 * ($cpt / $mesusers.count)
    write-progress -activity "$cpt / $($mesusers.count) -> $($_.nomcomplet)" -PercentComplete $pourcentage
    
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

$mesusers | ForEach-Object {}