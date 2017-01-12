
#see https://github.com/FedericoCeratto/nim-libsodium
# https://federicoceratto.github.io/nim-libsodium/docs/0.1.0/sodium.html#crypto_sign_keypair,

import strutils
import text
import hash
import libsodium.sodium
import libsodium.sodium_sizes


type
  EncoderSymmetric = object
    secret: string
    compress: bool

proc newSymmetricEncoder*( secret: string, compress=false ): EncoderSymmetric=
    var enc=EncoderSymmetric()
    var secretHash = hash.sha256(secret)
    enc.secret = secretHash
    enc.compress = compress
    result = enc

proc encrypt*(self: EncoderSymmetric, value: string): string =
    # if self.compress:
    #     echo "compress"
    result=crypto_secretbox_easy(key=self.secret, msg=value)

proc decrypt*(self: EncoderSymmetric, value: string): string =
    # if self.compress:
    #     echo "compress"
    result= crypto_secretbox_open_easy(key=self.secret, bulk=value)


import sophia

proc freeMem(obj: pointer) {.importc: "free", header: "<stdio.h>"}

# Create a Sophia environment
var env = env()

proc errorExit() =
  var size: cint
  var error = env.getstring("sophia.error", addr size);
  var msg = $(cast[ptr cstring](error)[])
  echo("Error: " & msg)
  freeMem(error)
  discard env.destroy()


# Set directory and add a db named test
discard env.setstring("sophia.path", "_test".cstring, 0)
discard env.setstring("db", "test".cstring, 0)

# Get the db
var db = env.getobject("db.test")

# Open the environment
var rc = env.open()
if (rc == -1):  errorExit()
echo "Opened Sophia env"
