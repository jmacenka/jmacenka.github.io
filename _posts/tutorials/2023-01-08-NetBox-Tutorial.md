---
# tutorial: https://chirpy.cotes.page/posts/write-a-new-post/
title: NetBox Tutorial
date: 2023-01-08 14:23:00 +0200
categories: [Tutorial]
tags: [networking,automation,tutorial,netbox]     # TAG names should always be lowercase
authors: [jan]
#pin: true
#comments: false
#mermaid: true
#math: true
---

![NetBox](/assets/img/logos/netbox.png)
# NetBox - The IT-Network planning and documentation system

Hi fellow Digitalisation-Colleagues,

many of us have need to inventory and monitor our shopfloor machine-infrastructure as well as the associated network infrastructure. The tool NetBox is a good fit for this need and was build with an API-first approach so it allows for a lot of automation. 

To give you an entry-point with some tutorials and guidance, I compiled this document/list.

Feel free to use and distribute. Cudos to Jeremy Cioara for his great tutorial series (see next section below). If after some research and experimentation you find your self treassuring the tool [which is OpenSource by the way](https://github.com/netbox-community/netbox/blob/develop/LICENSE.txt) as much as I do, consider supporting [the NetBox project](https://github.com/netbox-community/netbox/issues) or [Jeremy](https://www.kitsim.com/offers/rEe4hykQ/checkout) who is the creator of the video tutorials.

Since this tool is **much more** than the equivalent of an EXCEL-Spreadsheet with some IP-Addresses, you need to spend some time understanding the Tool and its structure upfront to get into a productive mode ;-)

To my understanding, this is time well spent as this REALLY is a powerfull tool for networking, automation understanding the basics/fundamentals: the physical layer of digitalisation in general!

# Setup guide

## Prerequisites
* Have a Linux Server with your package manager of choie, here we are assuming this will be the Aptitude-Package-Manager `apt`
* Be able to login via `SSH`, if you are on Windows you will need an additional Tool like [Putty](https://www.putty.org/), macOS and Linux come with essential CLI-Tools preinstalled.

## Tested with
As of January 2023, I have tested this build with:
* Ubuntu Server 22.04
    * <i class="fa fa-check" aria-hidden="true"></i> LXC Container under Proxmox
    * <i class="fa fa-check" aria-hidden="true"></i> Raspberry Pi 4B
    * <i class="fa fa-check" aria-hidden="true"></i> VM in Virtualbox
* Debian 11
    * <i class="fa fa-exclamation-triangle" aria-hidden="true"></i> LXC Container under Proxmox => docker-compose threw errors which I gave up debugging after a while

## Installation
Start by logging in to your Server then updating your system and installing git, docker and docker-compose 

```shell
apt update && apt upgrade -y
apt install git docker docker-compose -y
```

best to make a place on your server where the project can live like e.g.

```shell
mkdir -p ~/apps/netbox
cd ~/apps/netbox
```

then clone the original repository or if you like my fork of Version 2.4.0 (no further updates though) which includes [a backup-script](https://git.macenka.de/jan/netbox-docker/src/branch/release/backup_netbox_data_folders.sh)

```shell
# The original repository
git clone -b release https://github.com/netbox-community/netbox-docker.git .
```
{: file="~/apps/netbox" }

ALTERNATIVELY

```shell
# Jans fork of Version 2.4.0 (you might want to check if there are later versions) containing the backup-script
git clone https://git.macenka.de/jan/netbox-docker .
```
{: file="~/apps/netbox" }

with docker-compose it is best practice to have deployment-scripts for different environments like dev/QA/prod.

These are usually controlled by having differend docker-compose.overrides.yaml which are executed when calling `docker-compose up`, if you like you can specify special ones by invoking `docker-compose -f docker-compose.override-dev.yml`.

For now create this one

```shell
tee docker-compose.override.yml <<EOF
version: '3.4'
services:
  netbox:
    ports:
      - 8000:8080
EOF
```
{: file="~/apps/netbox" }

then deploy the service

```shell
docker-compose up -d
```
{: file="~/apps/netbox" }

netbox utilizes different services such as a PostgreSQL-Database which might take some time to come alive.

If you have not changed anything you should be able to whatch the Service start up by trailing the logs with 

```shell
docker logs -f netbox-docker_netbox_1
```

![](/assets/img/screenshots/2023-01-09_00-58_netbox-deployment-logs.png)

After a while you sould be able to access your instance by visiting

[http://localhost:8000](http://localhost:8000) if you installed it on your own system or exchanging `localhost` for the IP of your server.

![](/assets/img/screenshots/2023-01-09_00-58_netbox-dashboard.png)

login with the default credentials `admin / admin` your first action should be changing the admin password and storing it in your Passwortmanager ;-)

Next you should learn what NetBox realy is for which the following Video-Tutorials are a perfect fit.

## Video-Tutorial-Series

Best to start with this video:

{% include embed/youtube.html id='jr9Pxx0NkTc' %}

For even more detailed learning, see [these tutorials](https://www.kitsim.com/offers/rEe4hykQ/checkout).

<details>
    <summary>01 Installing NetBox 10 minutes</summary>

    {% include embed/youtube.html id='uHMXZpXpDvc' %}

</details>

<details>
    <summary>02 Keep Netbox Running After Reboot</summary>

    {% include embed/youtube.html id='djNis2wFfNU' %}

</details>

<details>
    <summary>03 Familiarizing Yourself with the Netbox Interface</summary>

    {% include embed/youtube.html id='tW-0IrxfKXE' %}

</details>

<details>
    <summary>04 The Netbox Bottom up Plan</summary>

    {% include embed/youtube.html id='WI6C0ZW8Upg' %}

</details>

<details>
    <summary>05 Your First Netbox Site</summary>

    {% include embed/youtube.html id='Ic_tuGBF4lQ' %}

</details>

<details>
    <summary>06 Site Region Tenant Design Examples</summary>

    {% include embed/youtube.html id='WugtkeMqYaA' %}

</details>

<details>
    <summary>07 Adding Racks</summary>

    {% include embed/youtube.html id='_TJ47rGpMio' %}

</details>

<details>
    <summary>08 Device Rolls</summary>

    {% include embed/youtube.html id='XSjqOfOiPJQ' %}

</details>

<details>
    <summary>09 Device Types</summary>

    {% include embed/youtube.html id='OvyqsEGKWwY' %}

</details>

<details>
    <summary>10 Device Type Components</summary>

    {% include embed/youtube.html id='UqZwxNc6oQI' %}

</details>

<details>
    <summary>11 Rack and Stack</summary>

    {% include embed/youtube.html id='5OCcNp4XLdA' %}

</details>

<details>
    <summary>12 Cabling</summary>

    {% include embed/youtube.html id='b-H-tSlZmZA' %}

</details>

<details>
    <summary>13 Power</summary>

    {% include embed/youtube.html id='mweHqHTTUIA' %}

</details>

<details>
    <summary>14 IPAM the Big Picture</summary>

    {% include embed/youtube.html id='TvQr4bGzK_Q' %}

</details>

<details>
    <summary>15 IPAM RIR and Aggregates</summary>

    {% include embed/youtube.html id='bhZxMoAVqWw' %}

</details>

<details>
    <summary>16 IPAM Prefixes and IP addresses the right way</summary>

    {% include embed/youtube.html id='zjNftvwbJ3M' %}

</details>

<details>
    <summary>17 IPAM the engineers way</summary>

    {% include embed/youtube.html id='foDVFjjKFgQfoDVFjjKFgQ' %}

</details>

<details>
    <summary>18 IPAM VLAN and VLAN Groups</summary>

    {% include embed/youtube.html id='M_DeOw_40RY' %}

</details>

<details>
    <summary>20 Circuits, DC Connection</summary>

    {% include embed/youtube.html id='_HKNRhWmnBs' %}

</details>

<details>
    <summary>21 Summary and Moving Forward</summary>

    {% include embed/youtube.html id='L80TglbMN70' %}

</details>

For even more detailed learning, see [these tutorials](https://www.kitsim.com/offers/rEe4hykQ/checkout).

## Backups and Restore

In the default setup NetBox uses Docker volumes and does (at least to my knowledge) not come with a backup/restore mechanism out of the box. As a good data-engineer after securing your password, making sure of backups should be one of your next steps ;-)

As a starter, you can review [my branch of the project](https://git.macenka.de/jan/netbox-docker) for which I added [this backup-script](https://git.macenka.de/jan/netbox-docker/src/branch/release/backup_netbox_data_folders.sh).

## Other Links and ressources
- [Project Repo](https://github.com/netbox-community/netbox)
- [Demo-setup to immediately start playing around with](https://demo.netbox.dev/)
- [Project Documentation - stable branch](https://docs.netbox.dev/en/stable/)
- If you need more in depth technical help:
    - [GitHub Discussion](https://github.com/netbox-community/netbox/discussions)
    - [Slack](https://netdev.chat/)
- [NetBox Wiki](https://github.com/netbox-community/netbox/wiki/Community-Contributions)
- [Ready to use docker-compose-setup](https://github.com/netbox-community/netbox-docker.git)
- [REST-API Docu](https://demo.netbox.dev/static/docs/rest-api/overview/)
- [GraphQL-API Docu](https://demo.netbox.dev/static/docs/graphql-api/overview/)
- [NetBox Docu für VMs und virtuelle Cluster](https://demo.netbox.dev/static/docs/core-functionality/virtualization/)