(:Azon szuperhősök tömbjének előállítása API-ból lekéréssel, akiknek az ereje (power) nagyobb, mint a megadott paraméter:)

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace array = "http://www.w3.org/2005/xpath-functions/array";

declare option output:method "json";
declare option output:media-type "application/json";

declare function local:getResultOfPower($power){
    let $superheroes := json-doc("https://akabab.github.io/superhero-api/api/all.json")?*
    return $superheroes[?powerstats?power  >= $power]
};

let $result :=local:getResultOfPower(100)

return array {$result}