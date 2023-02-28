# facile

function FCT_MEF-PNom {
    param($prenom, $nom)
    $PNom = $prenom.substring(0, 1).Toupper() + $nom.substring(0, 1).Toupper() + $nom.substring(1).ToLower()
    $PNom = $PNom.replace(" ", "")
    return $PNom
}

FCT_MEF-PNom -prenom "Elsa rose laire annie" -nom "versaire"