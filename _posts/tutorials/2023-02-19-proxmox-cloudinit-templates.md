---
# tutorial: https://chirpy.cotes.page/posts/write-a-new-post/
title: Proxmox Cloud-Init Templates for further Automation
date: 2023-02-22 20:00:00 +0200
categories: [Tutorials]
tags: [proxmox,coudinit,vm.provisioning,ubuntu]     # TAG names should always be lowercase
authors: [jan]
published: false
#pin: true
#comments: false
#mermaid: true
#math: true
---

<!-- ![Cloudinit](/assets/img/logos/cloudinit.webp) -->
![Cloudinit](https://ubuntu.com/wp-content/uploads/0954/cloudinit.png)

# Proxmox Cloud-Init Templates for further Automation

Dear fellow digitalization colleagues,

it is time we take a look on how to provision VMs in a way that supports true automation in an IaC (Infrastructure-as-Code) sense.

Today we will create a Cloud-Init Template for Ubuntu-22.04 Server Machines utilizing the Cloud-Init Template provided by Canonical. This will be done for a Proxmox instance and possibly later also for the VMware equivalents.

POST-EDIT: Cudos also to [this well written Blog-Post](https://codingpackets.com/blog/proxmox-import-and-use-cloud-images/) which does essentially the same thing but I only found afterwards ;-) Glad to see that our approaches converged.

## What are we going to do?

* Understand how we want to provision VMs in a way that supports true automation
* Setup a Proxmox VM-Template based on Ubuntu-22.04 Server with cloud-init

<!-- <style>
.responsive-wrap iframe{ max-width: 100%;}
</style>
<div class="responsive-wrap">
<iframe src="https://docs.google.com/presentation/d/e/2PACX-1vRNVSovbgHTohUFMsTmB-OroEyt9rg9oMMiyY_W_X6sJM1ZMNPBVd9kdJb7a66l7V--Iiw4kPHUmeYx/embed?start=false&loop=true&delayms=60000" frameborder="0" width="960" height="569" allowfullscreen="true" mozallowfullscreen="true" webkitallowfullscreen="true"></iframe>
</div> -->

Please note that:

> This is a **demo-setup** and it lacks any of the usual security precautions because you really need to think about them for yourselves! This can be taken as a starting point but is **NOT a production setup**!
{: .prompt-danger }

## Basic assumptions
- You are using a ZFS filesystem under your Proxmox
- Your harddrives are of category SSD

## Which technologies will we use?
* [Proxmox](https://www.proxmox.com/) >> A very good open source hypervisor platform
* [cloud-init](https://cloud-init.io/) >> A way of easily provisioning new Cloud VMs in a standardized way
 
# Setup guide

## Prerequisites

* [x] Have an up and running Instance of Proxmox with some space left over
    * The [WGET tool](https://www.gnu.org/software/wget/) should already be installed by default, if not run `sudo apt install wget -y`
* [x] Be able to login via SSH to your Proxmox-instance
* [x] Internet-Connection
* [x] Install [libguestfs](https://www.libguestfs.org/)

## Tested with

As of Feb 2023, I have tested this build with:
* Ubuntu Server 22.04 Minimal
    * <i class="fa fa-check" aria-hidden="true"></i> [Proxmox VE 7.3](https://pve.proxmox.com/wiki/Roadmap#Proxmox_VE_7.3)

## Installation

### Understanding the goal

Write some more here...

### Prepare the Proxmox Template

Assuming that you are operating on a system that offers a `bash` Shell environment, start by updating your system and installing the needed dependencies. I am assuming that your system provides a SUDO privilege tool, you can also switch to the root user and omit the `sudo` part of the commands.

First create a place on your system where the source-code will be pulled to:

```shell
mkdir -p ~/XYZ
cd ~/XYZ
```
{: file="~"}

### Download and modify the cloud-init file

Start by logging in to your Proxmox-VE Server via SSH by opening a terminal on your Laptop or control machine and usually typing something like

```shell
ssh root@pve
```
{: file="~"}

which should work if you have setup your `~/.ssh/config` file to point to your server. For example this file could look something like this:

```ini
Host pve
    HostName <HERE YOU PUT THE IP OF YOUR PVE-SERVER>
    User root
```
{: file="~/.ssh/config"}

To do everything in a way that your future self wont want to kick you for being a messy person, start by creating a directory with a descriptive name where we do our stuff.

```shell
mkdir -p ~/special_ISOs
cd ~/special_ISOs
```
{: file="~"}

Then download the Ubuntu 22.04 Minimal cloud-init ISO by running (if you read this in the future, feel free to swap out the URL for a more recent version)

```shell
# URL taken from https://cloud-images.ubuntu.com/minimal/releases/jammy/release/ 
# WGET should already come installed with PVE
wget https://cloud-images.ubuntu.com/minimal/releases/jammy/release/ubuntu-22.04-minimal-cloudimg-amd64.img
```
{: file="~/special_ISOs"}

As we want to use `qemu-geust-agent` on each of the VMs and we don't really want to install it manually, we will utilize the tool [libguestfs](https://www.libguestfs.org/) to modify and instal additional packages into our ISO-file.

Start by installing this tool on your Laptop or control machine, assuming that you use the [Aptitude Package Manager](https://wiki.debian.org/Aptitude), alternatively use your workflow of choice to install new packages.

```shell
sudo apt install libguestfs-tools -y
```
{: file="~/special_ISOs"}

To install `qemu-guest-agent` and `net-tools`into the ISO, run this command

```shell
# Should you use a different ISO-file obviously replace the pointer to the correct file
virt-customize -a ubuntu-22.04-minimal-cloudimg-amd64.img --install qemu-guest-agent net-tools
```
{: file="~/special_ISOs"}

This should output you something like this

![qemu-guest-agent installation screenshot](/assets/img/screenshots/2023-02-19_15-33_installing_qemu-guest-agent_into_ISO.png)

Next we need to connect the serial output of our VM which has ID of `9001` to our console, so we can see stuff inside the Proxmox Web-UI under the Console section by issuing

```shell
# Replace with other VM id if you did not pick 9001
qm set 9001 --serial0 socket --vga serial0
```

### Finalizing the template

# What to do next?

Some of the thinks you definitely should take care of next are:

* Secure logins and admin-accounts!
* Take care of Backups, you can take [this script](https://git.macenka.de/jan/netbox-docker-with-backup/src/branch/release/backup_netbox_data_folders.sh) as a starting point.


# Links and references
- [Proxmox VE Downloadpage](https://www.proxmox.com/en/downloads)
- [Ubuntu Minimal 22.04 LTS cloud.init Page](https://cloud-images.ubuntu.com/minimal/releases/jammy/release/)
- [libguestfs](https://www.libguestfs.org/) Tool for enhancing ISO-files, here is a [good post on how to use it](https://www.redhat.com/sysadmin/libguestfs-manage-vm).

Best regards,

[_Jan Macenka_](https://www.macenka.de)