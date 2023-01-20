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
highlighter: true
---

![NetBox](/assets/img/logos/netbox.png)
# NetBox - The IT-Network planning and documentation system

Hi fellow Digitalization-Colleagues,

many of us have need to inventory and monitor our shopfloor machine-infrastructure as well as the associated network infrastructure. The tool NetBox is a good fit for this need and was build with an API-first approach so it allows for a lot of automation. 

To give you an entry-point with some tutorials and guidance, I compiled this document/list.

Feel free to use and distribute. Cudos to [Jeremy Cioara](https://www.youtube.com/@KeepingITSimple/about) for his great tutorial series (see next section below). If after some research and experimentation you find your self treasuring the tool [which is OpenSource by the way](https://github.com/netbox-community/netbox/blob/develop/LICENSE.txt) as much as I do, consider supporting [the NetBox project](https://github.com/netbox-community/netbox/issues) or [Jeremy](https://www.kitsim.com/offers/rEe4hykQ/checkout) who is the creator of the video tutorials.

Since this tool is **much more** than the equivalent of an EXCEL-Spreadsheet with some IP-Addresses, you need to spend some time understanding the Tool and its structure upfront to get into a productive mode ;-)

To my understanding, this is time well spent as this REALLY is a powerful tool for networking, automation understanding the basics/fundamentals: the physical layer of digitalization in general!

# Setup guide

## Prerequisites
* Have a Linux Server with your package manager of choice, here we are assuming this will be the Aptitude-Package-Manager `apt`
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

### Basic setup

Start by logging in to your Server then updating your system and installing git, docker and docker-compose. I am assuming that your system provides a SUDO privilege tool, you can also switch to the root user and omit the `sudo` part of the commands:

```shell
sudo apt update && apt upgrade -y
sudo apt install git docker docker-compose -y
```

best to make a place on your server where the project can live like e.g.

```shell
mkdir -p ~/apps/netbox-docker
cd ~/apps/netbox-docker
```
### Load Software

then clone the original repository or if you like my fork of Version 2.4.0 (no further updates though) which includes [a backup-script](https://git.macenka.de/jan/netbox-docker-with-backup/src/branch/release/backup_netbox_data_folders.sh) that you need to manually modify.

```shell
# The original repository
git clone -b release https://github.com/netbox-community/netbox-docker.git .
```
{: file="~/apps/netbox" }

ALTERNATIVELY

```shell
# Jans fork of Version 2.4.0 (you might want to check if there are later versions) containing the backup-script
git clone https://git.macenka.de/jan/netbox-docker-with-backup .
```
{: file="~/apps/netbox-docker" }

### Configure Backups

if you chose this version, don't forget to update the backup-files variables

```shell
editor ~/apps/netbox-docker/backup_netbox_data_folders.sh
```
{: file="~/apps/netbox-docker" }

and register [a CRON-job](https://crontab.guru/#0_2_*_*_0) to run the backup cyclically. This one would run once per week `0 2 * * 0 bash ~/netbox-docker/backup_netbox_data_folders.sh`, you can use this script for automatically setting it up.

```shell
# Requires SUDO or manual switch to root-user
sudo (crontab -l && echo "0 2 * * 0 bash $PWD/backup_netbox_data_folders.sh") | crontab -
```

should this script fail just edit the cronjob manually using `crontab -e`

Also execute the script manually and make sure the backup-files actually end up in your NextCloud. 


> Please also be aware that **this is NOT a failsafe solution!** Also this backup script intentionally only keeps one backup copy on your system in order to not flood your system with to many backups and lock it ub. It is a quick and dirty solution and you need to understand it and see if you feel comfortable with it!
{: .prompt-danger }

### Deployment

The final thing to do is deployment for which we will use [docker-compose](https://docs.docker.com/compose/compose-file/).

With docker-compose it is best practice to have deployment-scripts for different environments like dev/QA/prod.

These are usually controlled by having different docker-compose.overrides.yaml which are executed when calling `docker-compose up`, if you like you can specify special ones by invoking `docker-compose -f docker-compose.override-dev.yml`.

For now create this one

```shell
cd ~/apps/netbox-docker # or navigate to the folder containing the repository
tee docker-compose.override.yml <<EOF
version: '3.4'
services:
  netbox:
    ports:
      - 8000:8080
EOF
```
{: file="~/apps/netbox-docker" }

Alternatively just create a `docker-compose.override.yml` file in the same directory as the repository with the contents listed in the command above. Then deploy the service

```shell
docker-compose up -d
```
{: file="~/apps/netbox" }

netbox utilizes different services such as a PostgreSQL-Database which might take some time to come alive.

If you have not changed anything you should be able to watch the Service start up by trailing the logs with 

```shell
docker logs -f netbox-docker_netbox_1
```

![](/assets/img/screenshots/2023-01-09_00-58_netbox-deployment-logs.png)

After a while you should be able to access your instance by visiting

[http://localhost:8000](http://localhost:8000) if you installed it on your own system or exchanging `localhost` for the IP of your server.

![](/assets/img/screenshots/2023-01-09_00-58_netbox-dashboard.png)

login with the default credentials `admin / admin` your first action should be to create a new user with admin privileges and inactivate the admin user while storing your new credentials in your password-manager ;-)

### Plugin Installation

Should you want to install further plugins to netbox, I recommend you follow [this official guide](https://github.com/netbox-community/netbox-docker/wiki/Using-Netbox-Plugins).

To fit my needs, I want to use NetBox also for graphical representations of the Networks. This can be achieved with the [netbox-topology-view](https://github.com/mattieserver/netbox-topology-views)-Plugin.

You can find a curated list of available plugins here: [https://github.com/netbox-community/netbox/wiki/Plugins#plugins-list](https://github.com/netbox-community/netbox/wiki/Plugins#plugins-list)

## Backups and Restore

In the [installation section](#configure-backups) we already saw a way for a **simplistic** backup mechanism. As each good systems and data-engineer should know: "You don't have a functional backup until you verified that also the restore-job works". With this in mind please make sure that you have an appropriate backup solution in place so you can feel save and secure. To me there are only view IT things more scary than losing network-documentation for systems you operate/maintain.

As a starter, you can review [my branch of the project](https://git.macenka.de/jan/netbox-docker) for which I added [this backup-script](https://git.macenka.de/jan/netbox-docker/src/branch/release/backup_netbox_data_folders.sh).

Next you should learn what NetBox really is for which the following Video-Tutorials are a perfect fit.

## Video-Tutorial-Series

There is an excellent video tutorial series by [Jeremy](https://www.youtube.com/@KeepingITSimple) which he also made available on YouTube. If you find that this is of value to you, please [consider supporting him for his work](https://www.kitsim.com/offers/rEe4hykQ/checkout)!

<details open>
    <summary>00 What is Netbox?</summary>

    {% include embed/youtube.html id='jr9Pxx0NkTc' %}

</details>


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

Some additional Videos for content that was not covered in the tutorials above:

<details>
    <summary>Introduction to Virtualization, Containers and Kubernetes</summary>

    {% include embed/youtube.html id='C0utPcvoTtA' %}

</details>

<details>
    <summary>Virtual Machines in NetBox</summary>

    {% include embed/youtube.html id='D5iDdjZMUeo' %}

</details>

## Naming conventions and how to input your data

Now that you have a working system, you should also think about ways to input your data, especially when working with others. 

When working with a tool like NetBox there is always more than one way to do things which is fine and even endorsed. However agreeing on a view high level conventions will make our lives much easier down the road if we can slice and dice the data we generated in a (as much as possible) similar way.

Here are some things that worked well for me

### Naming machines
We use the convention of naming machines according to their `hostname` which you can extract by entering the `hostname` command e.g. into an CMD-Terminal session.

Keep the hostname case-sensitive for the machine you want to register.

For MAC-Addresses we use the convention of inputting these as HEX-values with all upper-case letters and `:` as octet-delimiter.

### Networking principles
When entering IP-Addresses you will be asked to provide the Subnet-Mask in the [CIDR format](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing) which might be new to the occasional IT-User.

[In this list](https://docs.netgate.com/pfsense/en/latest/network/cidr.html) you can see the mapping between a Subnet-Mask and its CIDR. e.G. `255.255.255.0` equals a `/24` network. If you need even more help, [take a look at this tool](https://www.calculator.net/ip-subnet-calculator.html).

If your IP-Address was `192.168.0.100` with Subnet-Mask of `255.255.255.0` you would input `192.168.0.100/24` in the IP-field. If your Network is bigger it would be even better to plan a [10.x.y.z/8 Class A network](https://en.wikipedia.org/wiki/Private_network#Private_IPv4_addresses), which is intended for closed networks. As the available IP-Range of a `/8` network has potentially room for 16.777.216 devices, it is best practice to build subnet-ranges e.g. for Databases, Office-Clients or VMs.

### Working with TAGs
You can [use tags](https://docs.netbox.dev/en/stable/features/customization/#tags) with your components. Generally speaking all fields are filterable or queryable (also via the API).

For example its a good idea to tag the vendor of “stuff” that belongs together e.g. in one machine.

### Tenancy
NetBox has a great concept where you can have [multiple Tenants](https://docs.netbox.dev/en/stable/models/tenancy/tenant/) in your [Sites](https://docs.netbox.dev/en/stable/models/dcim/site/) and [Locations](https://docs.netbox.dev/en/stable/models/dcim/location/).

Later on this can be used for [access-right-governance](https://docs.netbox.dev/en/stable/administration/permissions/), so access-rule-constructed are possible where in the same dataset each tenant can only review (or other parts of [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete)) his/her stuff.

### Dummy Things
Some times you might not be able to find out more details about the “PC” or other System/Hardware you want to register, for this its best to use a `generic box pc` Template.

If you want to register a network connector or junction-box it also makes sense to register them as a `generic patch box` template.

If you don't have information on some of the non-required fields (even the name field), just leave it blank rather than put in some wrong information. You can always update these values later and even do batch-changes to many objects at once.

### Changes and Tracking&Tracing
Please be aware that there is [a change-log feature](https://docs.netbox.dev/en/stable/features/change-logging/) in NetBox so each change (also deletions) will be visible to others and at least to the admin!

# What to do next?
* Check that your admin-user credentials are safe and secure
* Check that there are no vulnerable API-Keys open in your system, as there is a default-one for the admin-user
* Make sure, you have a backup system in place

# Links and references
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
- [NetBox Docu für VMs und virtual Cluster](https://demo.netbox.dev/static/docs/core-functionality/virtualization/)

Best regards,

[_Jan Macenka_](https://www.macenka.de)