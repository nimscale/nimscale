
import nimSHA2, strutils

proc sha256*(value:string):string =
    var sha = initSHA[SHA256]()
    sha.update(value)
    let digest = sha.final()
    result = $digest

proc sha512*(value:string):string =
    var sha5 = initSHA[SHA512]()
    sha5.update(value)
    let digest = sha5.final()
    result = $digest
