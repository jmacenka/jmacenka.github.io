---
title: bitcoin hd wallet development tutorial
date: 2024-11-18 10:00:00 +0200
categories: [Tutorials]
tags: [bitcoin,development,hd-wallet,coding]
authors: [jan]
published: false
#pin: true
#comments: false
mermaid: true
#math: true
---

![Bitcoin Core](https://bitcoincore.org/assets/images/bitcoin_core_logo_colored_reversed.png)

# Building Your Own HD Bitcoin Wallet with Python

Dear fellow digitalization colleagues,

Welcome to the **HD Bitcoin Wallet Development Tutorial**! In this comprehensive guide, we'll walk you through building a Hierarchical Deterministic (HD) Bitcoin wallet from scratch using Python. This hands-on approach will help you understand Bitcoin's architecture, cryptographic principles, and the intricacies of implementing your own class-oriented Bitcoin library.

As you can likely tell, this was written [with the help of ChatGPT](https://chatgpt.com/c/673b9209-f958-800d-b53b-ecfbf51417e2).

## What are we going to do?

In this tutorial, we will:

1. **Understand the Basics of Bitcoin and HD Wallets**
2. **Explore Cryptographic Foundations**
3. **Implement Seed Generation and BIP-39 Mnemonics**
4. **Generate Master Keys as per BIP-32**
5. **Derive Child Keys**
6. **Generate Various Types of Bitcoin Addresses**
7. **Implement Standard Derivation Paths (BIP-44, BIP-49, BIP-84)**
8. **Create and Sign Bitcoin Transactions**
9. **Build a Class-Oriented Bitcoin Library**
10. **Test and Validate Our Implementation**
11. **Integrate Everything into a Functional HD Wallet**

<!-- <style>
.responsive-wrap iframe{ max-width: 100%;}
</style>
<div class="responsive-wrap">
<iframe src="https://docs.google.com/presentation/d/e/2PACX-1vRNVSovbgHTohUFMsTmB-OroEyt9rg9oMMiyY_W_X6sJM1ZMNPBVd9kdJb7a66l7V--Iiw4kPHUmeYx/embed?start=false&loop=true&delayms=60000" frameborder="0" width="960" height="569" allowfullscreen="true" mozallowfullscreen="true" webkitallowfullscreen="true"></iframe>
</div> -->

Please note that:

> This is a **demo-setup** and it lacks any of the usual security precautions because you really need to think about them for yourselves! This can be taken as a starting point but is **NOT a production setup**!
{: .prompt-danger }

## Which technologies will we use?

* [Python 3](https://www.python.org/) >> The primary programming language for our implementation.
* [ECDSA](https://pypi.org/project/ecdsa/) >> For elliptic curve cryptography operations.
* [Hashlib](https://docs.python.org/3/library/hashlib.html) >> To perform hashing functions like SHA-256 and RIPEMD-160.
* [HMAC](https://docs.python.org/3/library/hmac.html) >> For generating HMAC-SHA512 used in key derivations.
* [Base58](https://pypi.org/project/base58/) >> To encode Bitcoin addresses in Base58Check format.
* [Bech32](https://pypi.org/project/bech32/) >> For encoding native SegWit addresses.

# Setup guide

## Prerequisites

* **Python 3.8+** installed on your system.
* Basic understanding of **Python programming**.
* Familiarity with **Bitcoin concepts** and **cryptography**.
* **Git** installed for cloning repositories.
* **pip** package manager for installing Python libraries.

## Tested with

As of November 2024, I have tested this build with:

* **Operating Systems**
    * <i class="fa fa-check" aria-hidden="true"></i> **Ubuntu 22.04 LTS** [Download](https://releases.ubuntu.com/22.04/)
    * <i class="fa fa-check" aria-hidden="true"></i> **macOS Monterey** [Download](https://www.apple.com/macos/monterey/)
    * <i class="fa fa-exclamation-triangle" aria-hidden="true"></i> **Windows 10** [Download](https://www.microsoft.com/en-us/software-download/windows10)

## Installation

### Preparations

First, create a directory on your system where the source code and related files will be stored:

```shell
mkdir -p ~/bitcoin_hd_wallet
cd ~/bitcoin_hd_wallet
```
{: file="~"}

### Basic setup

Assuming you are operating on a system that offers a `bash` Shell environment, start by updating your system and installing the needed dependencies. It is assumed that your system provides a `sudo` privilege tool. You can also switch to the root user and omit the `sudo` part of the commands.

Install Python and Git if they are not already installed:

```shell
# Update package lists
sudo apt-get update

# Install Python 3 and pip
sudo apt-get install -y python3 python3-pip

# Install Git
sudo apt-get install -y git
```
{: file="~"}

### Load Software

Clone the repository where your HD wallet implementation will reside. For this tutorial, we'll assume it's a new repository. Alternatively, you can initialize a new Git repository.

```shell
# Clone the repository (replace LINK with your repository link if applicable)
git clone https://github.com/yourusername/bitcoin_hd_wallet.git .
```
{: file="~/bitcoin_hd_wallet"}

### Install Required Python Libraries

Install the necessary Python libraries using `pip`:

```shell
pip3 install ecdsa base58 bech32
```
{: file="~/bitcoin_hd_wallet"}

### Configure Deployment

For this tutorial, no additional configuration is required. All configurations will be handled within the Python scripts as we build the HD wallet.

### Deployment

No deployment steps are necessary since this is a development tutorial. We will be running Python scripts locally.

### Post deployment configuration

Ensure that your environment is secure:

* **Secure your development environment:** Use strong passwords and keep your system updated.
* **Handle private keys with care:** Do not expose or log private keys in your scripts or outputs.

# Module 1: Introduction to Bitcoin and HD Wallets

### Objectives

- Understand the basics of Bitcoin.
- Learn what HD wallets are and why they are important.
- Familiarize yourself with key BIPs (BIP-32, BIP-39, BIP-44, BIP-49, BIP-84).

### Content

#### What is Bitcoin?

- **Decentralized Digital Currency:** Bitcoin operates without a central authority, allowing peer-to-peer transactions.
- **Blockchain Technology:** A distributed ledger that records all Bitcoin transactions.
- **Transactions and Confirmations:** Transactions are grouped into blocks and confirmed by miners.

#### What is an HD Wallet?

- **Hierarchical Deterministic (HD) Wallets:** Defined by BIP-32, HD wallets generate a tree of keys from a single seed.
- **Advantages:**
  - **Single Seed for Multiple Keys:** Simplifies backups and restores.
  - **Easy Key Management:** Automatically handles key generation and organization.

#### Key Bitcoin Improvement Proposals (BIPs)

- **BIP-32:** Defines HD wallets.
- **BIP-39:** Mnemonic code for generating seeds.
- **BIP-44, BIP-49, BIP-84:** Define standard derivation paths for different address types.

### Activities

- **Reading:** Familiarize yourself with the [BIP-32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki), [BIP-39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki), [BIP-44](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki), [BIP-49](https://github.com/bitcoin/bips/blob/master/bip-0049.mediawiki), and [BIP-84](https://github.com/bitcoin/bips/blob/master/bip-0084.mediawiki) documents.
- **Discussion:** Understand the importance of HD wallets in modern cryptocurrency management.

---

# Module 2: Cryptographic Foundations

### Objectives

- Learn the cryptographic primitives used in Bitcoin.
- Understand elliptic curve cryptography (ECC) and the secp256k1 curve.
- Explore hashing functions like SHA-256 and RIPEMD-160.

### Content

#### Elliptic Curve Cryptography (ECC)

- **Basics of ECC:** A form of public-key cryptography based on the algebraic structure of elliptic curves.
- **secp256k1 Curve:** The specific elliptic curve used by Bitcoin.
- **Public and Private Keys:** Derived from each other; the private key is kept secret, while the public key is shared.

#### Hashing Functions

- **SHA-256:** Used in key generation and securing transactions.
- **RIPEMD-160:** Used in Bitcoin address generation.

#### Base Encoding Schemes

- **Base58Check:** Used for encoding Bitcoin addresses.
- **Bech32:** Used for native SegWit addresses.

### Code Examples

We'll use Python's `hashlib` and `hmac` libraries, and `ecdsa` for ECC.

```python
import hashlib
import hmac
from ecdsa import SECP256k1, SigningKey

# Example: Generate a private key
private_key = SigningKey.generate(curve=SECP256k1)
print(f"Private Key: {private_key.to_string().hex()}")

# Derive the public key
public_key = private_key.get_verifying_key()
print(f"Public Key: {public_key.to_string().hex()}")

# Hashing example
data = b"Hello, Bitcoin!"
sha256_hash = hashlib.sha256(data).digest()
print(f"SHA-256: {sha256_hash.hex()}")

ripemd160 = hashlib.new('ripemd160')
ripemd160.update(sha256_hash)
print(f"RIPEMD-160: {ripemd160.hexdigest()}")
```

### Activities

- **Exercise:** Generate and display a private-public key pair.
- **Exercise:** Perform SHA-256 and RIPEMD-160 hashing on sample data.

---

# Module 3: Seed Generation and BIP-39 Mnemonics

### Objectives

- Understand seed generation for HD wallets.
- Implement BIP-39 mnemonic code for generating human-readable seeds.

### Content

#### Seed Generation

- **Random Entropy Generation:** Securely generating random bytes as entropy.
- **Security Considerations:** Ensuring the randomness is sufficient to prevent attacks.

#### BIP-39 Mnemonics

- **Mnemonic Phrases:** Human-readable representation of the seed for easy backup.
- **Generation Process:** Converts entropy into a sequence of words from a predefined wordlist.

#### Implementing BIP-39

- **Generating Entropy:** Creating random bytes.
- **Creating Mnemonic Words from Entropy:** Mapping entropy bits to words.

### Code Examples

We'll implement a simple BIP-39 mnemonic generator using base libraries.

```python
import os
import hashlib

# BIP-39 English wordlist (only a small subset shown here for brevity)
WORDLIST = [
    "abandon", "ability", "able", "about", "above", "absent", "absorb",
    # ... (total 2048 words)
]

def generate_entropy(strength=128):
    """Generate entropy of specified bits."""
    return os.urandom(strength // 8)

def entropy_to_mnemonic(entropy):
    """Convert entropy to mnemonic phrase."""
    # Step 1: Calculate checksum
    hash_digest = hashlib.sha256(entropy).hexdigest()
    hash_bits = bin(int(hash_digest, 16))[2:].zfill(256)
    checksum_length = len(entropy) * 8 // 32
    entropy_bits = bin(int.from_bytes(entropy, byteorder='big'))[2:].zfill(len(entropy)*8)
    checksum = hash_bits[:checksum_length]
    bits = entropy_bits + checksum

    # Step 2: Split into 11-bit words
    words = []
    for i in range(len(bits) // 11):
        index = int(bits[i*11:(i+1)*11], 2)
        words.append(WORDLIST[index])
    return ' '.join(words)

# Example usage
entropy = generate_entropy()
mnemonic = entropy_to_mnemonic(entropy)
print(f"Entropy: {entropy.hex()}")
print(f"Mnemonic: {mnemonic}")
```

**Note:** For a complete implementation, you'll need the full BIP-39 wordlist (2048 words). You can download it from [BIP-39 Wordlist](https://github.com/bitcoin/bips/blob/master/bip-0039/english.txt).

### Activities

- **Exercise:** Complete the `WORDLIST` with all 2048 BIP-39 words.
- **Exercise:** Implement the full `entropy_to_mnemonic` function.
- **Exercise:** Create a reverse function `mnemonic_to_entropy` to decode mnemonics back to entropy.

---

# Module 4: Master Key Generation (BIP-32)

### Objectives

- Implement master key generation from the seed.
- Understand the structure of master private and public keys.

### Content

#### BIP-32 Overview

- **Hierarchical Deterministic Wallets:** Allows the creation of a tree of keys from a single seed.
- **Master Keys and Chain Codes:** The master private key and chain code are the root of the HD wallet.

#### Master Key Generation

- **HMAC-SHA512:** Used to derive master keys from the seed.
- **Separating Private Key and Chain Code:** The first 32 bytes are the master private key, and the last 32 bytes are the master chain code.

### Code Examples

```python
import hmac
import hashlib
from ecdsa import SigningKey, SECP256k1

def hmac_sha512(key, data):
    return hmac.new(key, data, hashlib.sha512).digest()

def generate_master_key(seed):
    """Generate master private key and chain code from seed."""
    I = hmac_sha512(b"Bitcoin seed", seed)
    master_private_key = I[:32]
    master_chain_code = I[32:]
    return master_private_key, master_chain_code

# Example usage
seed = generate_entropy(128)  # Using the function from Module 3
master_priv, master_chain = generate_master_key(seed)
print(f"Master Private Key: {master_priv.hex()}")
print(f"Master Chain Code: {master_chain.hex()}")
```

### Activities

- **Exercise:** Implement and test the `generate_master_key` function.
- **Exercise:** Explore how changing the seed affects the master keys.

---

# Module 5: Child Key Derivation

### Objectives

- Implement child key derivation as per BIP-32.
- Understand hardened and non-hardened derivations.

### Content

#### Derivation Paths

- **Structure:** `m / purpose' / coin_type' / account' / change / address_index`
- **Hardened vs. Non-Hardened:**
  - **Hardened:** More secure; derived using the parent private key.
  - **Non-Hardened:** Allows deriving child public keys from parent public keys.

#### Child Key Derivation

- **HMAC-SHA512:** Used with parent key and index to derive child keys.
- **Generating Child Private Keys and Chain Codes:** Combining parent keys with derived values.

#### Public Key Derivation

- **Deriving Child Public Keys from Parent Public Keys:** Possible with non-hardened derivations.

### Code Examples

```python
import struct
from ecdsa import SigningKey, SECP256k1, VerifyingKey

def derive_child_key(parent_private_key, parent_chain_code, index):
    """Derive a child key from parent key and chain code."""
    if index >= 0x80000000:
        # Hardened derivation: data = 0x00 + parent_priv_key + index
        data = b'\x00' + parent_private_key + struct.pack('>L', index)
    else:
        # Non-hardened derivation: data = parent_pub_key + index
        parent_priv_key_int = int.from_bytes(parent_private_key, 'big')
        parent_pub_key = SigningKey.from_string(parent_private_key, curve=SECP256k1).get_verifying_key().to_string("compressed")
        data = parent_pub_key + struct.pack('>L', index)
    
    I = hmac_sha512(parent_chain_code, data)
    Il, Ir = I[:32], I[32:]
    child_private_key_int = (int.from_bytes(Il, 'big') + int.from_bytes(parent_private_key, 'big')) % SECP256k1.order
    child_private_key = child_private_key_int.to_bytes(32, 'big')
    child_chain_code = Ir
    return child_private_key, child_chain_code

# Example usage
child_index = 0  # Change to desired index
child_priv, child_chain = derive_child_key(master_priv, master_chain, child_index)
print(f"Child Private Key: {child_priv.hex()}")
print(f"Child Chain Code: {child_chain.hex()}")
```

### Activities

- **Exercise:** Implement the `derive_child_key` function.
- **Exercise:** Derive multiple child keys and observe their uniqueness.
- **Exercise:** Implement both hardened and non-hardened derivations.

---

# Module 6: Address Generation (Legacy, Nested SegWit, Native SegWit)

### Objectives

- Generate Bitcoin addresses from public keys.
- Implement different address types: Legacy (P2PKH), Nested SegWit (P2SH-P2WPKH), and Native SegWit (Bech32).

### Content

#### Legacy Addresses (P2PKH)

- **Structure:** `RIPEMD160(SHA256(pubkey))`
- **Encoding:** Base58Check, starts with '1'.

#### Nested SegWit Addresses (P2SH-P2WPKH)

- **Encapsulation:** SegWit script within a P2SH address.
- **Encoding:** Base58Check, starts with '3' or '2' on testnet.

#### Native SegWit Addresses (Bech32)

- **Direct Use:** SegWit scripts without wrapping.
- **Encoding:** Bech32, starts with 'bc1' for Bitcoin mainnet.

### Code Examples

We'll implement functions to generate each address type.

```python
import hashlib
import base58
from typing import Tuple

# Placeholder for Bech32 encoding (to be implemented later)
def bech32_encode(hrp, data):
    # Implement Bech32 encoding or use a library
    pass

def hash160(data: bytes) -> bytes:
    """Perform RIPEMD160(SHA256(data))."""
    sha = hashlib.sha256(data).digest()
    rip = hashlib.new('ripemd160', sha).digest()
    return rip

def base58_check_encode(prefix: bytes, payload: bytes) -> str:
    """Encode payload with Base58Check."""
    data = prefix + payload
    checksum = hashlib.sha256(hashlib.sha256(data).digest()).digest()[:4]
    return base58.b58encode(data + checksum).decode()

def generate_p2pkh_address(public_key: bytes, testnet=False) -> str:
    """Generate Legacy P2PKH address."""
    pubkey_hash = hash160(public_key)
    prefix = b'\x6f' if testnet else b'\x00'
    return base58_check_encode(prefix, pubkey_hash)

def generate_p2sh_p2wpkh_address(public_key: bytes, testnet=False) -> str:
    """Generate Nested SegWit P2SH-P2WPKH address."""
    pubkey_hash = hash160(public_key)
    # Create the redeem script: OP_0 <20-byte-key-hash>
    redeem_script = b'\x00\x14' + pubkey_hash
    redeem_script_hash = hash160(redeem_script)
    prefix = b'\xc4' if testnet else b'\x05'
    return base58_check_encode(prefix, redeem_script_hash)

def generate_bech32_address(public_key: bytes, testnet=False) -> str:
    """Generate Native SegWit Bech32 address."""
    pubkey_hash = hash160(public_key)
    # For P2WPKH, witness version is 0
    witver = 0
    # Convert to 5-bit words
    data = [witver] + list(convertbits(pubkey_hash, 8, 5))
    hrp = 'tb' if testnet else 'bc'
    return bech32_encode(hrp, data)

# Helper function to convert bits
def convertbits(data, frombits, tobits, pad=True):
    """Convert bits from one base to another."""
    acc = 0
    bits = 0
    ret = []
    maxv = (1 << tobits) - 1
    for b in data:
        acc = (acc << frombits) | b
        bits += frombits
        while bits >= tobits:
            bits -= tobits
            ret.append((acc >> bits) & maxv)
    if pad:
        if bits:
            ret.append((acc << (tobits - bits)) & maxv)
    elif bits >= frombits or ((acc << (tobits - bits)) & maxv):
        return None
    return ret

# Example usage (assuming bech32_encode is implemented)
# public_key_compressed = public_key  # Compressed public key
# address_p2pkh = generate_p2pkh_address(public_key_compressed)
# address_p2sh_p2wpkh = generate_p2sh_p2wpkh_address(public_key_compressed)
# address_bech32 = generate_bech32_address(public_key_compressed)
# print(f"P2PKH Address: {address_p2pkh}")
# print(f"P2SH-P2WPKH Address: {address_p2sh_p2wpkh}")
# print(f"Bech32 Address: {address_bech32}")
```

**Note:** Implementing Bech32 encoding is non-trivial and will be covered in Module 6.3.

### Activities

- **Exercise:** Implement `generate_p2pkh_address` and test with known public keys.
- **Exercise:** Implement `generate_p2sh_p2wpkh_address` and verify with existing tools.
- **Exercise:** Research and implement Bech32 encoding or use a minimal library for `generate_bech32_address`.

---

# Module 7: Implementing Derivation Paths (BIP-44, BIP-49, BIP-84)

### Objectives

- Understand and implement standard derivation paths.
- Generate addresses according to different BIP standards.

### Content

#### Understanding Derivation Paths

- **BIP-44:** Legacy (P2PKH) addresses.
- **BIP-49:** Nested SegWit (P2SH-P2WPKH) addresses.
- **BIP-84:** Native SegWit (Bech32) addresses.

#### Derivation Path Structure

```
m / purpose' / coin_type' / account' / change / address_index
```


#### Implementing Different BIPs

- **Map BIP Numbers to Their Respective Purposes:**
  - **BIP-44:** `44'`
  - **BIP-49:** `49'`
  - **BIP-84:** `84'`
- **Automate the Derivation Based on Path:** Parsing and processing each segment.

### Code Examples

```python
def parse_derivation_path(path: str) -> list:
    """Parse derivation path string into list of indices."""
    if not path.startswith('m/'):
        raise ValueError("Path must start with 'm/'")
    elements = path.lstrip('m/').split('/')
    indices = []
    for e in elements:
        if e.endswith("'"):
            index = int(e[:-1]) + 0x80000000  # Hardened
        else:
            index = int(e)
        indices.append(index)
    return indices

# Example usage
path_bip49 = "m/49'/0'/0'/0/0"
indices = parse_derivation_path(path_bip49)
print(indices)  # [49 + 0x80000000, 0 + 0x80000000, 0 + 0x80000000, 0, 0]
```

### Activities

- **Exercise:** Implement the `parse_derivation_path` function.
- **Exercise:** Create a function to derive keys based on a given path.
- **Exercise:** Generate addresses for BIP-44, BIP-49, and BIP-84 paths and verify their correctness.

---

# Module 8: Transaction Creation and Signing

### Objectives

- Learn the structure of Bitcoin transactions.
- Implement transaction creation and signing.

### Content

#### Understanding Bitcoin Transactions

- **Inputs and Outputs:** Transactions consume UTXOs as inputs and create new outputs.
- **Transaction IDs and Serialization:** Unique identifiers and the format for network transmission.

#### Creating Transactions

- **Selecting UTXOs:** Choosing which unspent outputs to spend.
- **Building the Transaction Structure:** Assembling inputs, outputs, and other fields.

#### Signing Transactions

- **Creating Digital Signatures:** Authorizing the spending of UTXOs.
- **ScriptSigs and ScriptWitnesses:** Embedding signatures into transactions.

### Code Examples

Given the complexity, we'll outline the basic structure for creating and signing a transaction.

```python
from ecdsa import SECP256k1, SigningKey

def create_raw_transaction(inputs: list, outputs: list, version=1, locktime=0) -> bytes:
    """Create a raw Bitcoin transaction."""
    # Serialize version
    raw_tx = version.to_bytes(4, 'little')
    
    # Serialize input count
    raw_tx += encode_varint(len(inputs))
    
    # Serialize each input
    for tx_input in inputs:
        raw_tx += bytes.fromhex(tx_input['txid'])[::-1]  # txid little endian
        raw_tx += tx_input['vout'].to_bytes(4, 'little')  # vout
        raw_tx += encode_varint(len(tx_input['script']))  # script length
        raw_tx += tx_input['script']
        raw_tx += tx_input['sequence'].to_bytes(4, 'little')
    
    # Serialize output count
    raw_tx += encode_varint(len(outputs))
    
    # Serialize each output
    for tx_output in outputs:
        raw_tx += tx_output['value'].to_bytes(8, 'little')  # amount in satoshis
        raw_tx += encode_varint(len(tx_output['script']))  # script length
        raw_tx += tx_output['script']
    
    # Serialize locktime
    raw_tx += locktime.to_bytes(4, 'little')
    
    return raw_tx

def encode_varint(i: int) -> bytes:
    """Encode integer as Bitcoin varint."""
    if i < 0xfd:
        return i.to_bytes(1, 'little')
    elif i <= 0xffff:
        return b'\xfd' + i.to_bytes(2, 'little')
    elif i <= 0xffffffff:
        return b'\xfe' + i.to_bytes(4, 'little')
    else:
        return b'\xff' + i.to_bytes(8, 'little')

# Example usage (simplified)
inputs = [{
    'txid': 'e3c0...',  # Previous transaction ID
    'vout': 0,
    'script': b'',  # Placeholder
    'sequence': 0xffffffff
}]
outputs = [{
    'value': 100000,  # in satoshis
    'script': b''  # Placeholder
}]
raw_tx = create_raw_transaction(inputs, outputs)
print(raw_tx.hex())
```

**Note:** This is a highly simplified version. Proper transaction creation involves handling scripts, calculating the correct scripts for inputs and outputs, and more. Implementing full transaction signing is beyond this snippet's scope and will be covered in more depth.

### Activities

- **Exercise:** Implement the `create_raw_transaction` function.
- **Exercise:** Explore UTXO selection and how to build inputs.
- **Exercise:** Implement digital signature creation for transaction inputs.

---

# Module 9: Building the Class-Oriented Library

### Objectives

- Organize the implemented functions into a coherent, class-based Python library.
- Ensure modularity and reusability of components.

### Content

#### Designing the Library Structure

- **Classes:** `HDWallet`, `Key`, `Transaction`, etc.
- **Encapsulation of Functionalities:** Group related functions and data within classes.

#### Implementing Classes

**Example: HDWallet Class**

```python
import os
import hmac
import hashlib
from ecdsa import SigningKey, SECP256k1, VerifyingKey
from typing import Tuple

class HDWallet:
    def __init__(self, seed: bytes):
        self.master_priv, self.master_chain = self.generate_master_key(seed)
    
    @staticmethod
    def generate_master_key(seed: bytes) -> Tuple[bytes, bytes]:
        I = hmac.new(b"Bitcoin seed", seed, hashlib.sha512).digest()
        return I[:32], I[32:]
    
    def derive_path(self, path: str) -> Tuple[bytes, bytes]:
        indices = parse_derivation_path(path)
        priv_key, chain_code = self.master_priv, self.master_chain
        for index in indices:
            priv_key, chain_code = derive_child_key(priv_key, chain_code, index)
        return priv_key, chain_code
    
    def get_private_key(self, path: str) -> bytes:
        priv_key, _ = self.derive_path(path)
        return priv_key
    
    def get_public_key(self, path: str) -> bytes:
        priv_key = self.get_private_key(path)
        return SigningKey.from_string(priv_key, curve=SECP256k1).get_verifying_key().to_string("compressed")
    
    def get_address(self, path: str, addr_type='p2pkh', testnet=False) -> str:
        pub_key = self.get_public_key(path)
        if addr_type == 'p2pkh':
            return generate_p2pkh_address(pub_key, testnet)
        elif addr_type == 'p2sh-p2wpkh':
            return generate_p2sh_p2wpkh_address(pub_key, testnet)
        elif addr_type == 'bech32':
            return generate_bech32_address(pub_key, testnet)
        else:
            raise ValueError("Unsupported address type")
```

**Example: Key Class**

```python
class Key:
    def __init__(self, private_key: bytes):
        self.private_key = private_key
        self.public_key = SigningKey.from_string(private_key, curve=SECP256k1).get_verifying_key().to_string("compressed")
    
    def sign(self, message: bytes) -> bytes:
        sk = SigningKey.from_string(self.private_key, curve=SECP256k1)
        signature = sk.sign_deterministic(message, hashfunc=hashlib.sha256)
        return signature
```

### Activities

- **Exercise:** Refactor existing functions into class methods.
- **Exercise:** Implement additional classes like `Transaction` to handle transaction creation and signing.
- **Exercise:** Ensure the library handles edge cases and errors gracefully.

---

# Module 10: Testing and Validation

### Objectives

- Validate the correctness of your implementation.
- Test the library against known test vectors and use cases.

### Content

#### Unit Testing

- **Write Tests for Each Function and Class Method:** Ensure individual components work as expected.
- **Use Python's `unittest` Framework:** Organize and run tests systematically.

#### Integration Testing

- **Test the Entire Wallet Flow:** From seed generation, key derivation, address creation, to transaction signing.

#### Security Considerations

- **Handle Private Keys Securely:** Avoid exposing or logging sensitive information.
- **Use Secure Random Number Generators:** Ensure entropy is sufficiently random.
- **Validate All Inputs:** Prevent invalid data from causing unexpected behavior.

### Code Examples

**Example: Testing Derivation Path Parsing**

```python
import unittest

class TestDerivationPath(unittest.TestCase):
    def test_parse_derivation_path(self):
        path = "m/44'/0'/0'/0/0"
        expected = [44 + 0x80000000, 0 + 0x80000000, 0 + 0x80000000, 0, 0]
        result = parse_derivation_path(path)
        self.assertEqual(result, expected)

if __name__ == '__main__':
    unittest.main()
```

### Activities

- **Exercise:** Write unit tests for all functions.
- **Exercise:** Perform integration tests by generating addresses and verifying them with external tools like [Blockchain Explorer](https://www.blockchain.com/explorer).
- **Exercise:** Review and enhance the library's security measures.

---

# Final Project: Building a Functional HD Wallet

### Objectives

- Integrate all modules into a cohesive, functional HD wallet.
- Implement additional features as needed.

### Content

#### Combining Modules

- **Use the `HDWallet` Class:** Generate seeds, derive keys, and create addresses.
- **Implement a User Interface:** CLI or Jupyter Notebook-based for interacting with the wallet.

#### Advanced Features

- **Support Multiple Accounts:** Handle different user accounts within the wallet.
- **Implement Address Indexing and Management:** Organize and track generated addresses.
- **Handle Transaction Broadcasting:** Requires network interaction to send transactions to the Bitcoin network.

### Code Examples

**Example: Generating Addresses Using HDWallet**

```python
# Initialize HDWallet with seed
seed = generate_entropy(128)
wallet = HDWallet(seed)

# Derive and get P2PKH address
path = "m/44'/0'/0'/0/0"
address_p2pkh = wallet.get_address(path, addr_type='p2pkh')
print(f"P2PKH Address: {address_p2pkh}")

# Derive and get Nested SegWit address
path = "m/49'/0'/0'/0/0"
address_p2sh_p2wpkh = wallet.get_address(path, addr_type='p2sh-p2wpkh')
print(f"P2SH-P2WPKH Address: {address_p2sh_p2wpkh}")

# Derive and get Native SegWit address
path = "m/84'/0'/0'/0/0"
address_bech32 = wallet.get_address(path, addr_type='bech32')
print(f"Bech32 Address: {address_bech32}")
```

### Activities

- **Exercise:** Use the final library to generate different types of addresses.
- **Exercise:** Test transaction creation and signing (requires setting up a testnet environment).
- **Exercise:** Document the library's usage and functionalities.

---

# Links and references

- [Bitcoin Developer Guide](https://bitcoin.org/en/developer-guide)
- [BIP-32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki)
- [BIP-39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki)
- [BIP-44](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki)
- [BIP-49](https://github.com/bitcoin/bips/blob/master/bip-0049.mediawiki)
- [BIP-84](https://github.com/bitcoin/bips/blob/master/bip-0084.mediawiki)
- [ECDSA Python Library](https://pypi.org/project/ecdsa/)
- [Base58 Python Library](https://pypi.org/project/base58/)
- [Bech32 Python Library](https://pypi.org/project/bech32/)
- [Bitcoin Testnet Explorer](https://www.blockchain.com/explorer)
- [BIP-39 Wordlist](https://github.com/bitcoin/bips/blob/master/bip-0039/english.txt)

Best regards,

[_Jan Macenka_](https://www.macenka.de)
