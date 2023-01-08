---
# tutorial: https://chirpy.cotes.page/posts/write-a-new-post/
title: NetBox Tutorial
date: 2023-01-08 14:23:00 +0200
categories: [Tutorial]
tags: [networking,automation,tutorial,netbox]     # TAG names should always be lowercase
authors: [jan]
#pin: true
comments: false
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

# Installation guide

## Prerequisites
* Have a Linux Server with your package manager of choie, here we are assuming this will be the Aptitude-Package-Manager `apt`
* 

## Setup
Start by updating your system and installing docker and docker-compose 

```shell
apt update && apt upgrade -y
apt install docker docker-compose
```

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