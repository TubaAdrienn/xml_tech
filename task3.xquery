(:Finding heros with aliases and adding them to an XML document:)
xquery version "3.1";
import schema default element namespace "" at "task3.xsd";
declare namespace array = "http://www.w3.org/2005/xpath-functions/array";
declare namespace validate = "http://basex.org/modules/validate";

declare function local:getHerosWithAliases(){
    let $superheroes := json-doc("https://akabab.github.io/superhero-api/api/all.json")?*
    return $superheroes[?biography?aliases?1  != "-"]
};

let $heroes :=local:getHerosWithAliases()

let $document := 
    <heroes xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:noNamespaceSchemaLocation="task3.xsd">
        {
          for $hero in $heroes
          return 
          <hero id="{$hero?id}">
            <name>{$hero?name}</name>
            <aliases>
            {
                for $alias in $hero?biography?aliases?*
                return <alias>{$alias}</alias>
            }
            </aliases>
          </hero>
        }
    </heroes>
    
return validate {$document}



