#Facile
function FCT_MEF-Prenom {
    param ($prenom)
    $prenom.Substring(0, 1).ToUpper() + $prenom.Substring(1).ToLower()
    return $prenom
}
FCT_MEF-Prenom -prenom "AliCe"

function FCT_MEF-PrenomHard {
    param($prenom)
    # Prend en charge les prénom simple, améliorer avec les prénoms composés
    # prévoir tous les cas possibles (faire un jeu d'essai)
    $prenom = ($prenom.replace(" ","-").Split("-") | ForEach-Object {
        $_.substring(0,1).ToUpper()+$_.substring(1).ToLower()
    }) -join '-'
    return $prenom
}

FCT_MEF-PrenomHard -prenom "AliCe-qsdsdsdqdsq qsdqsd"