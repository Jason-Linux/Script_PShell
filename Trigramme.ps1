# facile

function FCT_MEF-Trigramme {
    param($prenom, $nom)
    $Tri = $prenom.substring(0, 1).Toupper() + $nom.substring(0, 1).Toupper() + $nom.substring($nom.length - 1).ToUpper()
    $Tri = $Tri.replace(" ", "")
    return $Tri
}

FCT_MEF-Trigramme -prenom "Elsa rose laire annie" -nom "versaire"