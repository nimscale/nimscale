import strutils
import math

proc padMultiple16*(value:string):string =
    #pad string to have X nr of 16, useful for e.g. encryption

    #padd for 16 bytes
    #roundup (is this ok????)
    var len16=math.round(float64(len(value))/16.0+0.49999999999999)
    var lenall=len(value)
    var topadd=(int(len16)+0)*16-lenall
    result=value & strutils.repeat(" ",topadd)
