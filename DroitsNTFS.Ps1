# Droit NTFS Recréée sur chaque user pour attribuer des droits sur mesure sur le dossier Home

$RootUserath = "C:\_Partages\_Users"

$listeusers = get-aduser -filter * 
$listeusers | foreach-object {
    $user = $_.samaccountname

    $userfullpath = Join-path $RootUserath $user

    new-item -ItemType Directory -path $userfullpath -Force
    $ACL = Get-ACL $userfullpath

    # Droit n°0
    $FSR0 = "FullControl"
    $ACT0 = [AccessControlType]::Allow
    $IDRef0 = "AUTORITE NT\Système"
    $OICI0 = [InheritanceFlags]::ContainerInherit -bor [InheritanceFlags]::ObjectInherit
    $Pflag0 = [PropagationFlags]::None
    $ACO0 = [FileSystemAccessRule]::new($IDRef0, $FSR0, $OICI0, $Pflag0, $ACT0)
    # Droit n°1
    $FSR1 = "FullControl"
    $ACT1 = [AccessControlType]::Allow
    $IDRef1 = "BUILTIN\Administrateurs"
    $OICI1 = [InheritanceFlags]::ContainerInherit -bor [InheritanceFlags]::ObjectInherit
    $Pflag1 = [PropagationFlags]::None
    $ACO1 = [FileSystemAccessRule]::new($IDRef1, $FSR1, $OICI1, $Pflag1, $ACT1)
    # Droit n°2
          
    $FSR2 = "DeleteSubdirectoriesAndFiles", "Write", "ReadAndExecute", "Synchronize"
    $ACT2 = [AccessControlType]::Allow
    $IDRef2 = "$env:userdomain\$user"
    $OICI2 = [InheritanceFlags]::ContainerInherit -bor [InheritanceFlags]::ObjectInherit
    $Pflag2 = [PropagationFlags]::None
    $ACO2 = [FileSystemAccessRule]::new($IDRef2, $FSR2, $OICI2, $Pflag2, $ACT2)
    # Droit n°3
    $FSR3 = "Delete", "Synchronize"
    $ACT3 = [AccessControlType]::Allow
    $IDRef3 = "$env:userdomain\$user"
    $OICI3 = [InheritanceFlags]::ContainerInherit -bor [InheritanceFlags]::ObjectInherit
    $Pflag3 = [PropagationFlags]::InheritOnly
    $ACO3 = [FileSystemAccessRule]::new($IDRef3, $FSR3, $OICI3, $Pflag3, $ACT3)

    $acl.SetAccessRuleProtection($true, $false)
    $acl.AddAccessRule($aco0)
    $acl.AddAccessRule($aco1)
    $acl.AddAccessRule($aco2)
    $acl.AddAccessRule($aco3)
    Set-acl -Path $userfullpath -AclObject $ACL 
}