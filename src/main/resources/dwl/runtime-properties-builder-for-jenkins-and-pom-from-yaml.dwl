%dw 2.0
output text/plain
import fail from dw::Runtime

var delimiter = "="
var lineSeparator = "\n"

fun collapseKeys(data, joiner=".", keys=[]) =
    data match {
        case is Object -> data mapObject (v, k) -> 
                              collapseKeys(v, joiner, keys + k)
        else -> if (isEmpty(keys))// If an object was passed, we should have at least one key 
                    fail("collapseKeys: Did not receive Object") 
                else
                    {(keys joinBy joiner): data}
    }
    
var hashMap= collapseKeys(payload)

fun YAMLtoProperty() = hashMap pluck ("$($$)=$( if(($ contains "regex:") or ($ contains " ") ) "\"$\"" else $)") joinBy lineSeparator

fun jenkinsScript() = hashMap pluck ("-D$($$)=$( if(($ contains "regex:") or ($ contains " ") ) "\"$\"" else $)") joinBy " "

fun jenkinsSecrettextVariable() = hashMap pluck ("$($)") filter ($ contains "\${") map ("string(credentialsId: '$', variable: '$')") joinBy ","

fun pom() = hashMap pluck ("<$$>\${$$}</$$>") joinBy lineSeparator
---
//YAMLtoProperty()
jenkinsScript()
//jenkinsSecrettextVariable()
//pom()