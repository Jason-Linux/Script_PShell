# ┌∩┐(◣_◢)┌∩┐
#Script Dangeureux, attention à ne pas faire n'importe quoi
# tout usage est à vos risques et péril, Jason-Linux décline toute responsabilité 
#dans le cas ou vous péter tout l'annuaire

Get-ADOrganizationalUnit -filter * -SearchBase "OU=_Services,$ldapdomainname" |
Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false

Get-ADOrganizationalUnit -filter * -SearchBase "OU=_Services,$ldapdomainname" |
Remove-ADOrganizationalUnit -Recursive -Confirm:$false

Get-adgroup -filter * -Properties *  | 
where whencreated -gt (get-date).addhours(-2) | 
Remove-ADGroup -Confirm:$false

Get-aduser -filter * | remove-aduser -Confirm:$false
#┌∩┐(◣_◢)┌∩┐ Vous êtes prévenus !