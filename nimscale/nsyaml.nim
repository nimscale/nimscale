import yaml.serialization, yaml.presenter, streams

import strutils
import streams


proc dumps*[T](value:T):string =
    var s = newStringStream()
    serialization.dump(value, s, options = defineOptions(
        style = psCanonical,
        indentationStep = 4,
        newlines = nlLF))
        # outputVersion = ov1_1))
    setPosition(s,0)
    let ss=s.readAll()
    # let ss2=replace(ss,"!n!nil:string \"\"","")
    # let ss3=replace(ss2,"!n!nil:seq \"\"","")
    # discard ss
    # discard ss2
    # echo(ss3)
    s.close()
    result=ss
