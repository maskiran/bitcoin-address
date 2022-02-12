from audioop import add
import hashlib

from ecdsa import SigningKey, SECP256k1
import base58

priv_key = SigningKey.generate(SECP256k1)
pub_key = priv_key.verifying_key

# to_string returns bytes, its a carry over code from python2
address = {}
for key_type in ['uncompressed', 'compressed']:
    hash1 = hashlib.sha256(pub_key.to_string(key_type))
    hash2 = hashlib.new('ripemd160')
    hash2.update(hash1.digest())
    network_hash = b'\x00' + hash2.digest()
    address[key_type] = base58.b58encode_check(network_hash)

print("Private Key:                  ", priv_key.to_string().hex())
print("")
print("Public Key Uncompressed:      ", pub_key.to_string("uncompressed").hex())
print("Bitcoin Address Uncompressed: ", address['uncompressed'].decode())
print("")
print("Public Key Compressed:        ", pub_key.to_string("compressed").hex())
print("Bitcoin Address Compressed:   ", address['compressed'].decode())
