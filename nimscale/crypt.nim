
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
