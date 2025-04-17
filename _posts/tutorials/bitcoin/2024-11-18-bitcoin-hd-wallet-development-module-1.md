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

'''shell
mkdir -p ~/bitcoin_hd_wallet
cd ~/bitcoin_hd_wallet
'''
{: file="~"}

### Basic setup

Assuming you are operating on a system that offers a `bash` Shell environment, start by updating your system and installing the needed dependencies. It is assumed that your system provides a `sudo` privilege tool. You can also switch to the root user and omit the `sudo` part of the commands.

Install Python and Git if they are not already installed:

'''shell
# Update package lists
sudo apt-get update

# Install Python 3 and pip
sudo apt-get install -y python3 python3-pip

# Install Git
sudo apt-get install -y git
'''
{: file="~"}

### Load Software

Clone the repository where your HD wallet implementation will reside. For this tutorial, we'll assume it's a new repository. Alternatively, you can initialize a new Git repository.

'''shell
# Clone the repository (replace LINK with your repository link if applicable)
git clone https://github.com/yourusername/bitcoin_hd_wallet.git .
'''
{: file="~/bitcoin_hd_wallet"}

### Install Required Python Libraries

Install the necessary Python libraries using `pip`:

'''shell
pip3 install ecdsa base58 bech32
'''
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

## Objectives

- **Understand the basics of Bitcoin.**
- **Learn what HD wallets are and why they are important.**
- **Familiarize yourself with key BIPs (BIP-32, BIP-39, BIP-44, BIP-49, BIP-84).**

## Content

### What is Bitcoin?

**Bitcoin** is a decentralized digital currency that operates without a central authority, allowing peer-to-peer transactions over the internet. Here's a breakdown of its fundamental components:

- **Decentralized Digital Currency:** Unlike traditional currencies issued by central banks, Bitcoin is maintained by a network of computers (nodes) distributed globally. This decentralization ensures that no single entity has control over the entire system.
  
- **Blockchain Technology:** Bitcoin transactions are recorded on a public ledger known as the blockchain. This blockchain is a chain of blocks, each containing a list of transactions. The blockchain ensures transparency and immutability, meaning once a transaction is recorded, it cannot be altered.
  
- **Transactions and Confirmations:** When you send Bitcoin to someone, the transaction is broadcasted to the network. Miners (nodes that validate transactions) include this transaction in a block. Once a block is added to the blockchain, the transaction receives confirmations. The more confirmations a transaction has, the more secure it is considered.

### What is an HD Wallet?

An **HD Wallet** (Hierarchical Deterministic Wallet) is a type of Bitcoin wallet defined by [BIP-32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki). It allows the generation of a tree-like structure of keys from a single seed. Here's why HD wallets are significant:

- **Hierarchical Structure:** HD wallets organize keys in a hierarchical manner, allowing for the creation of multiple accounts, each with its own set of addresses. This structure simplifies key management and enhances privacy.

- **Deterministic Generation:** From a single seed (a random string of bytes), an HD wallet can generate an entire tree of keys. This means you only need to back up the seed to recover all your keys, making backups more manageable.

- **Advantages:**
  - **Single Seed for Multiple Keys:** Simplifies the backup process since you don't need to back up each key individually.
  - **Enhanced Privacy:** By generating a new address for each transaction, HD wallets help in maintaining privacy by not linking multiple transactions to a single address.
  - **Ease of Use:** Automatically handles key generation and organization, reducing the complexity for the user.

### Key Bitcoin Improvement Proposals (BIPs)

**Bitcoin Improvement Proposals (BIPs)** are design documents providing information to the Bitcoin community or describing a new feature for Bitcoin or its processes. Several BIPs are crucial for HD wallet implementation:

- **BIP-32:** Defines HD wallets, detailing how to generate a tree of keys from a single seed, including key derivation methods.

- **BIP-39:** Introduces mnemonic codes (a set of easy-to-remember words) for generating deterministic wallets. This makes backing up and restoring wallets more user-friendly.

- **BIP-44:** Specifies a standard derivation path for multi-account hierarchical deterministic wallets. It ensures interoperability between different wallet implementations.

- **BIP-49:** Defines a standard derivation path for nested SegWit addresses (P2SH-P2WPKH). Nested SegWit enhances compatibility with older systems while benefiting from SegWit features.

- **BIP-84:** Specifies a standard derivation path for native SegWit addresses (Bech32). Native SegWit offers better efficiency and lower transaction fees.

## Activities

1. **Reading:**
   - **BIP-32:** [BIP-32 Document](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki)
   - **BIP-39:** [BIP-39 Document](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki)
   - **BIP-44:** [BIP-44 Document](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki)
   - **BIP-49:** [BIP-49 Document](https://github.com/bitcoin/bips/blob/master/bip-0049.mediawiki)
   - **BIP-84:** [BIP-84 Document](https://github.com/bitcoin/bips/blob/master/bip-0084.mediawiki)
   
   Familiarize yourself with these documents to understand the standards and methodologies behind HD wallets.

2. **Discussion:**
   - **Importance of HD Wallets:** Reflect on how HD wallets simplify key management, enhance security, and improve user experience in Bitcoin transactions.
   - **Privacy Implications:** Consider how generating multiple addresses from a single seed can protect user privacy by preventing address reuse.

3. **Hands-On:**
   - **Explore Existing HD Wallets:** Install and explore popular HD wallets like [Electrum](https://electrum.org/#home) or [Bitcoin Core](https://bitcoincore.org/en/download/) to see HD wallet principles in action.
   - **Mnemonic Generation:** Use online tools to generate BIP-39 mnemonic phrases and understand how entropy translates to mnemonic words.

## Conclusion

In Module 1, we've laid the foundation by understanding what Bitcoin is, the significance of HD wallets, and the key BIPs that govern their functionality. This knowledge is crucial as we move forward to implement each component of the HD wallet in Python. Ensure you are comfortable with these concepts, as they will be integral to the subsequent modules where we dive deeper into the technical implementation.

---
