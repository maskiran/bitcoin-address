#! /bin/bash

# pip install base58

# Website to get the Bitcoin address from public key
# https://iancoleman.io/bitcoin-key-compression/

# Website to check the procedure to convert public key to address
# http://gobittest.appspot.com/Address

# Bitcoin Address Technical Background
# https://en.bitcoin.it/wiki/Technical_background_of_version_1_Bitcoin_addresses

PRIVATE_KEY_FILE="privatekey.pem"

# check if an existing private key file is provided as cli argument
if [ "$1" != "" ]; then
    PRIVATE_KEY_FILE=$1
fi

# generate the ecdsa private key if the file does not exist
if [ ! -f $PRIVATE_KEY_FILE ]; then
    openssl ecparam -name secp256k1 -genkey -out $PRIVATE_KEY_FILE
fi

# no need to dump public key, as i can read the private and
# public key strings from the text output of the private key file
# openssl ec -in $PRIVATE_KEY_FILE -pubout -out publickey.pem

prv_string=$(openssl ec -in $PRIVATE_KEY_FILE -text -noout 2>/dev/null | grep "priv:" -A 3 | grep -v "priv:" | tr -d ' :\n')
pub_string=$(openssl ec -in $PRIVATE_KEY_FILE -text -noout 2>/dev/null | grep "pub:" -A 5 | grep -v "pub:" | tr -d ' :\n')
pub_string_comp=$(openssl ec -in $PRIVATE_KEY_FILE -text -noout -conv_form compressed 2>/dev/null | grep "pub:" -A 3 | grep -v "pub:" | tr -d ' :\n')

# To get the bitcoin hash address
# SHA256 of the Public Key -> gives hash1
# RIPEMD160 of the above hash (hash1) -> gives hash2
# Prefix 00 to the above hash -> gives network_hash
# base58 of the above hash -> gives bitcoin address

# the public key is the hex string in ascii format, convert that to the machine (binary) format
# using xxd -r -p

# base58 -c (addchecksum option) calculates the checksum hashes, so checksum need not be
# calculated specifically as described in the above websites

# Uncompressed Address
hash1=$(echo -n $pub_string | xxd -r -p | openssl sha256)
hash2=$(echo $hash1 | xxd -r -p | openssl ripemd160)
network_hash="00$hash2"
address=$(echo $network_hash | xxd -r -p | base58 -c )

# Compressed Address
hash1=$(echo -n $pub_string_comp | xxd -r -p | openssl sha256)
hash2=$(echo $hash1 | xxd -r -p | openssl ripemd160)
network_hash="00$hash2"
address_comp=$(echo $network_hash | xxd -r -p | base58 -c )

echo "Private Key:                  $prv_string"
echo
echo "Public Key UnCompressed:      $pub_string"
echo "Bitcoin Address Uncompressed: $address"
echo
echo "Public Key Compressed:        $pub_string_comp"
echo "Bitcoin Address Compressed:   $address_comp"
