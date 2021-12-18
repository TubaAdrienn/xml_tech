(: Megadott típusú hősök szűrése :)

declare namespace array = "http://www.w3.org/2005/xpath-functions/array";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";

declare option output:method "json";
declare option output:media-type "application/json";

declare function local:getResultOfSpecies($race){
    let $superheroes := json-doc("https://akabab.github.io/superhero-api/api/all.json")?*
    return $superheroes[?appearance?race  = $race]
};

let $heroes :=local:getResultOfSpecies("Alien")

return array {
    for $hero in $heroes
    where exists($hero?name)
    order by $hero?name ascending
    return map {
        "name": $hero?name,
        "gender": $hero?appearance?gender,
        "powerstat": $hero?powerstats
    }
}

