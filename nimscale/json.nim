import yaml.serialization, yaml.presenter, streams

import strutils
import streams

template toJSON*(result:untyped, value: untyped) =
    import yaml.serialization, yaml.presenter, streams
    var s = newStringStream()
    #psJson makes it to serialze to json
    serialization.dump(value, s, options = defineOptions(
        style = psJson,
        indentationStep = 2,
        newlines = nlLF))
    setPosition(s,0)
    result=s.readAll()
    s.close()

template toYAML*(result:untyped, value: untyped) =
    import yaml.serialization, yaml.presenter, streams
    var s = newStringStream()
    serialization.dump(value, s, options = defineOptions(
        style = psBlockOnly,
        indentationStep = 2,
        newlines = nlLF))
    setPosition(s,0)
    result=s.readAll()
    s.close()
