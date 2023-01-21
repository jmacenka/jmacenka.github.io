---
# tutorial: https://chirpy.cotes.page/posts/write-a-new-post/
title: How to setup Guacamole remote access in a secure way
date: 2023-01-20 14:33:00 +0200
categories: [Descriptions]
tags: [vnc,remote-access,security,totp]     # TAG names should always be lowercase
authors: [jan]
published: false
#pin: true
#comments: false
#mermaid: true
#math: true
---

![](URL_TO_BANNER)

# TITLE

Dear fellow digitalization colleagues,

INTRODUCTION TEXT

## What are we going to do?

OUTLINE OF THE DESCRIPTION/TUTORIAL

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
* [TECHNOLOGY](LINK) >> DESCRIPTION OF TECHNOLOGY

# Setup guide

## Prerequisites

* BULLETPOINT PREREQUISITES

## Tested with

As of XXX 2023, I have tested this build with:
* OS
    * <i class="fa fa-check" aria-hidden="true"></i> THIS SUCCEEDED [OS_TYPE](LINK)
    * <i class="fa fa-exclamation-triangle" aria-hidden="true"></i> THIS FAILED

## Installation

### Preparations

In order to grant `SSH` access to the machines you want to control, it is best practice (even if its only your home-network) deny all connections and grant individual access.

The best thing to do is to generate SSH-Certificates utilizing the [`ssh-keygen` command](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).

The next best thing is to grant access on a per-IP-basis for which on the client machine you have to edit the `/etc/hosts.allow` file

```shell
sudo editor /etc/host.allow
```

here you can input e.g. the following

```
sshd : localhost : allow
sshd : 192.168.0. : allow
sshd : 99.151.250.7 : allow
sshd : mydomain.net : allow
sshd : ALL : deny
```
{: file="/etc/host.allow"}

The above entry will allow ssh access from localhost, the 192.168.0.x subnet, the single IP address 99.151.250.7, and mydomain.net (assuming mydomain.net has a ptr record in place to facilitate reverse lookup). All other IP addresses will be denied access to sshd.

To connect via VNC to the Machines (if you need to use a GUI interface), you can install TightVNC

```shell
sudo apt install xfce4 xfce4-goodies
sudo apt install tightvncserver
```

then create a user dedicated to the service

```shell
sudo adduser vnc-viewer
sudo passwd vnc-viewer
```

then set the password for the vnc service

```shell
su -  vnc-viewer
vncpasswd
```

if you run a ufw firewall service, you need to open the port for the vnc service

```shell
ufw allow 5901/tcp
```


### Basic setup

Assuming that you are operating on a system that offers a `bash` Shell environment, start by updating your system and installing the needed dependencies. I am assuming that your system provides a SUDO privilege tool, you can also switch to the root user and omit the `sudo` part of the commands.

First create a place on your system where the source-code will be pulled to:

```shell
mkdir -p ~/XYZ
cd ~/XYZ
```
{: file="~"}

### Load Software

Then start a new shell and clone the repository your working directory

```shell
# Clone the repository
cd ~/XYZ
git clone LINK .
```
{: file="~/XYZ"}

### Configure Deployment

### Deployment

### Post deployment configuration

# What to do next?

Some of the thinks you definitely should take care of next are:

* Secure logins and admin-accounts!
* Take care of Backups, you can take [this script](https://git.macenka.de/jan/netbox-docker-with-backup/src/branch/release/backup_netbox_data_folders.sh) as a starting point.


# Links and references
- [DESCRIPTION](LINK)

Best regards,

[_Jan Macenka_](https://www.macenka.de)