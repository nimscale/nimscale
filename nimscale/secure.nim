import options
import os
import leveldb
import strutils
import math
from options import nil


type
  SecureDB* = object
    db: leveldb.LevelDb
    key: string
    sync: bool
    aes: AESContext
    compress: bool
    encrypt: bool


proc encode*(self: SecureDB, value: string): string =
    if self.compress:
        echo "compress"
    if self.encrypt:
        #padd for 16 bytes
        #roundup (is this ok????)
        var len16=int(float(len(value))/16.0+0.5)
        var lenall=len(value)
        var topadd=(len16+1)*16-lenall
        echo topadd
        echo "len: "& repr(topadd)
        # var value1=strutils.align(value, llen, padding = ' ')
        # value=self.aes.encryptCBC(value)

    result=value
    #

proc decode*(self: SecureDB, value: string): string =
    result=value
    #let decrypted = self.aes.decryptCBC(value)


proc put*(self: SecureDB, key: string, value: string) =
    var value2 = self.encode(value)
    self.db.put(key,value2,sync=self.sync)

proc get*(self: SecureDB, key: string): Option[string] =
    var res = self.db.get(key)
    if options.isNone(res):
        result= res
    else:
        var value = options.get(res)
        var decrypted=self.decode(value)
        result = some(decrypted)

proc open*( secret:string, path: var string="", sync=true,encrypt=true,compress=true): SecureDB =


    # new(result)

    var sdb=SecureDB()
    if path=="":
        path="local.db"
    else:
        path=os.joinPath(path,"local.db")

    #find the key on the localfilesystem
    var key = "0123456789ABCDEF"

    assert sdb.aes.setEncodeKey(key)==true
    assert sdb.aes.setDecodeKey(key)==true
    sdb.key=""
    result.db=leveldb.open(path)
    result.sync=sync
    result.encrypt=encrypt
    result.compress=compress


proc close*(self: SecureDB) =
    if self.db == nil:
        return
    self.db.close()
    # self.db = nil
