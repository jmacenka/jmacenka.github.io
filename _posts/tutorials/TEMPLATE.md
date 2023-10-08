---
# tutorial: https://chirpy.cotes.page/posts/write-a-new-post/
title: TEMPLATE
date: 2023-MM-DD hh:mm:00 +0200
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

Should look like this:
![](/assets/img/screenshots/XYZ.png)

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