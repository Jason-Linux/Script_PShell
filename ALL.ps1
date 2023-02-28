function FCT_MEF-Prenom {
    param($prenom)
    # Prend en charge les prénom simple, améliorer avec les prénoms composés
    # prévoir tous les cas possibles (faire un jeu d'essai)
    $prenom = ($prenom.replace(" ", "-").Split("-") | ForEach-Object {
            $_.substring(0, 1).ToUpper() + $_.substring(1).ToLower()
        }) -join '-'
    return $prenom
}
function FCT_MEF-Nom {
    param($nom)
    $maxlength = "30"
    if ($nom.length -cgt $maxlength) {
        $nomcorriger = $nom.Substring(0, 29).ToUpper().replace("-", " ")
    }
    else {
        $nomcorriger = $nom.Substring(0).ToUpper().replace("-", " ")
    }
    
    return $nomcorriger   
}
function FCT_MEF-Initiales {
    param($prenom, $nom)
    $initiales = ($prenom.Substring(0, 1) + $nom.substring(0, 1)).toupper()
    return $initiales
}
function FCT_MEF-Trigramme {
    param($prenom, $nom)
    $Trigramme = ($prenom.Substring(0, 1) + $nom.substring(0, 1) + $nom[-1]).toupper()
    return $Trigramme
}
function FCT_MEF-Nomcomplet {
    param($prenom, $nom)
    $nomcomplet = $prenom.Substring(0, 1).ToUpper() + $prenom.Substring(1).ToLower() + " " + $nom.ToUpper()
    return $nomcomplet
}
function FCT_MEF-Email {
    param($prenom, $nom)
    $email = $prenom.substring(0, 1) + $nom + "@" + $env:USERDNSDOMAIN
    $email = $email.replace(" ", "").tolower() 
    return $email
}
function FCT_MEF-Pnom {
    param($prenom, $nom)
    $pnom = (($prenom.Substring(0, 1) + $nom).replace(" ", "").tolower()).replace("-", "")
    return $pnom
}

function FCT_MEF-Get-RNDPASS {
    param ($nbcar)
    $liste = 65..90 + 97..122 + 48..57 + 64 + 33..47
    $mdp = (get-random -inputobject $liste -count $nbcar | ForEach-Object { [char]$_ }) -join ''
    
    return $mdp
}
function FCT_MEF-Edit-User {
    param($objuser)
    $prenom = FCT_MEF-Prenom     -prenom $objuser.prenom
    $nom = FCT_MEF-Nom                                -nom $objuser.nom
    $initiales = FCT_MEF-Initiales  -prenom $prenom         -nom $nom
    $trigramme = FCT_MEF-trigramme  -prenom $prenom         -nom $nom
    $nomcomplet = FCT_MEF-NomComplet -prenom $prenom         -nom $nom
    $email = FCT_MEF-Email      -prenom $prenom         -nom $nom
    $pnom = FCT_MEF-Pnom       -prenom $prenom         -nom $nom 
    $user = [pscustomobject] @{
        idrh       = $objuser.idrh
        service    = $objuser.service
        grade      = $objuser.grade
        fonction   = $objuser.fonction
        prenom     = $prenom    
        nom        = $nom       
        initiales  = $initiales 
        trigramme  = $trigramme 
        nomcomplet = $nomcomplet
        email      = $email     
        pnom       = $pnom 
        pass       = FCT_MEF-Get-RNDPass -nbcar 13     
      
    }
    return $user
}
function FCT_MEF-New-User {
    param($prenom, $nom)
    $user = [pscustomobject] @{
        prenom = (FCT_MEF-Prenom    -prenom $prenom)
        nom    = (FCT_MEF-Nom       -nom $nom)
    }
    $user | add-member -mem noteproperty -name "initiales"  -value (FCT_MEF-Initiales  -prenom $_.prenom -nom $_.nom) 
    $user | add-member -mem noteproperty -name "trigramme"  -value (FCT_MEF-trigramme  -prenom $_.prenom -nom $_.nom)
    $user | add-member -mem noteproperty -name "nomcomplet" -value (FCT_MEF-NomComplet -prenom $_.prenom -nom $_.nom)
    $user | add-member -mem noteproperty -name "email"      -value (FCT_MEF-Email      -prenom $_.prenom -nom $_.nom)
    $user | add-member -mem noteproperty -name "pnom"       -value (FCT_MEF-Pnom       -prenom $_.prenom -nom $_.nom)
    $user | add-member -mem noteproperty -name "password"   -value (FCT_MEF-Get-RNDPASS -nbcar  "16")
     

    return $user
}