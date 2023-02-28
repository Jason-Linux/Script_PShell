# facile

function FCT_MEF-Mail {
    param($prenom, $nom, $domaine)
    $PNom = $prenom.substring(0, 1).Toupper() + $nom.substring(0, 1).Toupper() + $nom.substring(1).ToLower()
    $mail = $PNom+'@'+$domaine.ToLower()
    $mail = $mail.replace(" ","").ToLower()
    return $mail
}

FCT_MEF-Mail -prenom "Elsa rose laire annie" -nom "versaire" -domaine "frOux.com"