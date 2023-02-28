#Facile
<#
function FCT_MEF-Nom {
    param ($nom)
    $nom.Substring(0).Toupper()
    return $nom
}

FCT_MEF-Nom -Nom "roux"
#>

#Moyen

function FCT_MEF-Nom {
    param ($nom)
    $maxlength = "30"
    if ($nom.length -cgt $maxlength) {
        $nom.Substring(0, 29).ToUpper().replace("-", " ")
        return $nom
    }
    else {
        $nom.Substring(0).ToUpper().replace("-", " ")
        return $nom
    }   
}

FCT_MEF-Nom -Nom "roux-de-de-deiozerioiezopripozeirpoiezorilkeoprzieorizpoeripozeirpozierpoizeporizpoeirpozieporiopzerpozeirpoiz"

