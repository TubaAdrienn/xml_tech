(:Returns an associative array of superheroes and their BMI if they have the required values :)
(:Metric forumula: (weigth (kg) / height^2 (cm)) * 10000 :)
xquery version "3.1";
declare namespace array = "http://www.w3.org/2005/xpath-functions/array";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace op = "http://www.w3.org/2002/08/xquery-operators";

declare function local:getValue($metric){
    let $value := fn:tokenize($metric, ' '),
    $value := fn:replace($value[1],',' , '')
    return xs:double($value)
};

declare function local:calculateBMI($weigth, $height){
    let $heightValue := local:getValue($height), $weigthValue := local:getValue($weigth),
    $result := ($weigthValue div ($heightValue * $heightValue)) * 10000 
    return $result
};

let $heroes := json-doc("https://akabab.github.io/superhero-api/api/all.json")?*,  
    $heroes := $heroes[?appearance?weight?1  != "- lb" and ?appearance?height?1  != "-"],
    $result := map:merge(for $h in $heroes 
               return map:entry($h?name, local:calculateBMI( $h?appearance?weight => array:get(2),$h?appearance?height => array:get(2) ))) 
               => serialize(map{'method': 'json'})

return $result