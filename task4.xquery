(:Gathers top 5 strongest marvel human hero by powerstat averages:)
xquery version "3.1";
import schema default element namespace "" at "task4.xsd";
declare namespace array = "http://www.w3.org/2005/xpath-functions/array";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace op = "http://www.w3.org/2002/08/xquery-operators";

declare function local:getHumanAndMarvelHeroes(){
    let $superheroes := json-doc("https://akabab.github.io/superhero-api/api/all.json")?*
    let $marvel := $superheroes[?biography?publisher  = "Marvel Comics"]
    return $marvel[?appearance?race ="Human"]
};

declare function local:getAverageStats($heroes){
    for $hero in $heroes
    let $avg := local:average($hero?powerstats)
    return
        map {
            "id": $hero?id,
            "name": $hero?name,
            "avg": $avg,
            "powerstats": $hero?powerstats
        }
};

declare function local:average($powerstats){
    let $stat := ($powerstats?intelligence + $powerstats?strength + $powerstats?durability+ $powerstats?speed+ $powerstats?power+ $powerstats?combat)
    return fn:round($stat div 6, 3)
};

let $heroes := local:getHumanAndMarvelHeroes()
let $averages := local:getAverageStats($heroes)

return validate {
    document {
            <heroes xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:noNamespaceSchemaLocation="task4.xsd">{
                for $p at $pos in (
                for $stat in $averages
                let $avg := $stat?avg
                    order by $avg descending
                return 
                <hero id="{$stat?id}">
                    <name>{$stat?name}</name>
                    <avg>{$avg}</avg>
                    <powerstats>
                        <intelligence>{$stat?powerstats?intelligence}</intelligence>
                        <strength>{$stat?powerstats?strength}</strength>
                        <speed>{$stat?powerstats?speed}</speed>
                        <power>{$stat?powerstats?power}</power>
                        <durability>{$stat?powerstats?durability}</durability>
                        <combat>{$stat?powerstats?combat}</combat>
                    </powerstats>
                </hero>
                ) where $pos le 5
                return $p
                }
            </heroes>
        }
    }