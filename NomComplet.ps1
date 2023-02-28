# facile

function FCT_MEF-NomComplet {
    param($prenom, $nom)
    $NComplet = $prenom.substring(0, 1).Toupper() + $prenom.substring(1).ToLower() + " " + $nom.substring(0).ToUpper()
    $NComplet = $NComplet.replace(" ", "")
    return $NComplet
}

FCT_MEF-NomComplet -prenom "Elsa rose laire annie" -nom "versaire"