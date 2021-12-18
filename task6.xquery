(:Number of superheroes and villains of each publisher:)
xquery version "3.1";
import schema default element namespace "" at "task6.xsd";
declare namespace array = "http://www.w3.org/2005/xpath-functions/array";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare function local:countHeroes($heroes, $publisher, $alignment){
    let $result := count($heroes[?biography?publisher eq $publisher and ?biography?alignment eq $alignment])
    return $result
};

declare function local:countCharacters($heroes){
    let $publishers := distinct-values($heroes?biography?publisher)
    for $publisher in $publishers
    where $publisher != ""
    return
        map {
            "name": $publisher,
            "characters": map {
            "heroes": local:countHeroes($heroes, $publisher, "good"),
            "villains":local:countHeroes($heroes, $publisher, "bad"),
            "neutral": local:countHeroes($heroes, $publisher, "neutral")
            }
        } 
};


let $superheroes := json-doc("https://akabab.github.io/superhero-api/api/all.json")?*,
$result:= local:countCharacters($superheroes)

let $document := 
    <publishers xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="task6.xsd">
        { 
        for $res in $result
        return
        <publisher>
        <name>{$res?name}</name>
        <character-counts>
            {
                for $i in ('villains','neutral','heroes')
                let $current := map:get($res?characters, $i)
                where $current != 0
                (:return <character>{map:get($res?characters,$i)}</character>:)
                return if($i eq 'villains') then <villain-count>{$current}</villain-count> 
                else if($i eq 'neutral') then <neutral-count>{$current}</neutral-count> 
                else <hero-count>{$current}</hero-count> 
            }
        </character-counts>
        </publisher>
        }
    </publishers>
    
return validate {$document}