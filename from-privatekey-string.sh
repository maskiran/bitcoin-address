# Private key can be any 32 byte string (represented as 64 hex chars). 
# This 32 bit string can be generated using a random numbers or any other way

# echo helloworld | openssl sha256
# 8cd07f3a5ff98f2a78cfc366c13fb123eb8d29c1ca37c79df190425d5b9e424d

# To be able to generate public key from the above, add a prefix and suffix 
# with openssl magical strings for the secp256k1 elliptical curve
# I found these using google and landed on stackoverflow and some websites

PRIVATE_KEY_FILE="string-privatekey.pem"
secp256k1_prefix="302e0201010420"
secp256k1_suffix="a00706052b8104000a"
private_key="6571e57d45e75d4803a4415c16d25d47827235d75a9bbf44c74df1e7b3db826f"

input="${secp256k1_prefix}${private_key}${secp256k1_suffix}"

openssl ec -inform DER -in <(echo -n $input | xxd -r -p) -out $PRIVATE_KEY_FILE 2>/dev/null

# once the privatekey is generated, use the script in openssl-cmds.sh

bash openssl-cmds.sh $PRIVATE_KEY_FILE