# facile

function FCT_MEF-Initiales{
    param($prenom,$nom)
    $initiales = $prenom.substring(0,1).Toupper() + $nom.substring(0,1).Toupper()
    $initiales = $initiales.replace(" ", "")
    return $initiales
}

FCT_MEF-Initiales -prenom "Elsa rose laire annie" -nom "versaire"