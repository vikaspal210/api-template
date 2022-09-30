%dw 2.0
output text/plain
//output application/json
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
fun objectToArray (root) = root pluck ("$($$)=$( if($ contains " ") "\"$\"" else $)")

fun YAMLtoProperty() = objectToArray(convertToProperties("", "", payload)) joinBy lineSeparator

fun jenkinsScript() = convertToProperties("", "", payload) pluck ("-D$($$)=$( if($ contains " ") "\"$\"" else $)") joinBy " "

fun jenkinsSecrettextVariable() = convertToProperties("", "", payload) pluck ("$($)") filter ($ contains "\${") map ("string(credentialsId: '$', variable: '$')") joinBy ","

fun pom() = convertToProperties("", "", payload) pluck ("<$$>\${$$}</$$>") joinBy lineSeparator
---
//YAMLtoProperty()
jenkinsScript()
//jenkinsSecrettextVariable()
//pom()
