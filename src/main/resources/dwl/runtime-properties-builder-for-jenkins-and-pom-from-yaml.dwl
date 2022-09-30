%dw 2.0
output text/plain
import * from dw::core::Strings

var delimiter = "="
var lineSeparator = "\n"
fun generateKey (parentKey, childKey) = (
   if (parentKey == "" and childKey == "")
       ""
   else if (parentKey == "" and childKey != "")
       childKey
   else
       parentKey ++ "." ++ childKey
)
fun convertToProperties (parentKey, childKey, childNode) = (
   if (typeOf(childNode) == Object )
       childNode mapObject( convertToProperties(log('parentKey', generateKey(parentKey, childKey)), log('childKey',$$), log('childNode',$)))
   else if (typeOf(childNode) == Array )
       (generateKey(parentKey, childKey)): childNode joinBy ","
   else (generateKey(parentKey, childKey)): childNode
)
fun convertJSONToArray (root) = (
   (root mapObject ( str: "$$" as String ++ delimiter ++ if($ contains " ") "\"$($)\"" else ($ as String) )).*str
)

fun YAMLtoProperty() = convertJSONToArray(convertToProperties("", "", payload)) joinBy lineSeparator

fun jenkinsScript() = convertJSONToArray(convertToProperties("", "", payload)) map ("-D$($)") joinBy " "

fun jenkinsSecrettextVariable() = convertJSONToArray(convertToProperties("", "", payload)) map(substringAfter($,"=")) filter ($ contains "\${") map ("string(credentialsId: '$', variable: '$')") joinBy ","

fun pom() = convertJSONToArray(convertToProperties("", "", payload)) map (substringBefore($,"=")) map ("<$>\${$}</$>") joinBy lineSeparator
---
//YAMLtoProperty()
//jenkinsScript()
//jenkinsSecrettextVariable()
pom()