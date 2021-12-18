(:Superhero with most workplaces:)
declare namespace array = "http://www.w3.org/2005/xpath-functions/array";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "json";
declare option output:media-type "application/json";

declare function local:getWorks($works){
    let $token := fn:replace($works, ';',',')
    let $token := fn:tokenize($token, ',') 
    return $token
};

declare function local:getHerosWithWorks($heroes){
    for $hero in $heroes
    let $work :=  local:getWorks($hero?work?occupation)
    return
        map {
            "id": $hero?id,
            "name": $hero?name,
            "size": count($work),
            "works": array {$work}
        } 
};

let $heroes := json-doc("https://akabab.github.io/superhero-api/api/all.json")?*
let $result := local:getHerosWithWorks($heroes), 
    $max := $result ! ?size => max()

let $max-hero := $result[?size eq $max]

return $max-hero
