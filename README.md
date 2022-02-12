# bitcoin-address
Scripts to generate bitcoin private key, public key and address in compressed and uncompressed forms using python, openssl

# Requirements
```
pip install -r requirements.txt
```

# Using openssl commands
```
bash openssl-cmds.sh
```

# Using an existing 32 byte hex string that you want to use as a private key
```
bash from-privatekey-string.sh <key_string>

# e.g
key_str=$(echo "helloworld" | openssl sha256)
bash from-privatekey-string.sh $key_str
```

# Using Python
```
pip install -r requirements.txt
python address.py
```