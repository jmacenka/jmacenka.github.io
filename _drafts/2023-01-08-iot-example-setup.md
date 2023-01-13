---
# tutorial: https://chirpy.cotes.page/posts/write-a-new-post/
title: IoT Example Setup
date: 2023-01-13 14:34:00 +0200
categories: [Tutorial]
tags: [iot,iac,automation,nodered,influxdb,grafana,ansible,terraform]     # TAG names should always be lowercase
authors: [jan]
#pin: true
comments: false
#mermaid: true
#math: true
---

![]()
# IoT Example Setup

Dear fellow digitalization Colleagues,

when dealing with digitalization in the sense of IoT in an industrial seup, you probably at some point come across the Node-Red / infulxDB / Grafana setup as of 2023.access

I did so aswell and will describe to you my journey together with some added code and snippets for building deployment pipelines that you can take as a starting point for your journey.

Please be aware that this is NOT AT ALL a production ready setup and intentionally leaves out all usual security-preconsiderations as there is no one size fits all solution. Hence we will deploy our ressources in an INSECURE WAY that you definetly would want to adapt if you would like to utilize this setup in an production environment.

Also we wont take any data-backuping considerations but if you would like to get an idea of how to backup a generic dockerized payload in a simplistic way, you might start [with this script as a reference]().

# What technologies will we use?
* [Docker]() -> Containerization engine
* [docker-compose]() -> Container configuration management
* DigitalOcean -> Cloud plattform providing compute and storage
* terraform -> Automated resource provisioning for creating and later tearing down resources in an automated manner
* Ansible -> Server configuratoin management for setting up the new ressources

# What are we going to do?

* Clone and modify a Repository containting an example Setup with Node-Red + InfluxDB +  Grafana
* Create an account at DigitalOcean, which will serve as our cloud to deploy our ressources to. If you feel like it, go ahead and deploy onto your own cloud like VMWare-ESXi or Proxmox or what ever hypervisor-System you are using
* Deploy the payloads to our could-environment
* Visite the services and to some post-installation steps which intentionally where left non-automated
* Inspect the configured Data-Stream which subscribes to a public MQTT-Node that streams data for a weather station utilizing a pre-built Grafana-Dashboard
* Tear down the entire setup again and if you like to, change/adapt and start the process all over again

# Prerequisites?
* Habe a host- or control-machine where you can install stuff onto
* Have an active internet connection
* Have or register an accoutn at DigitalOcean if you want to follow the first step of the example

# Installation

1. Make sure you have the require dependencies installed on your machine
   - [SSH](https://docs.microsoft.com/de-de/windows-server/administration/openssh/openssh_install_firstuse) (only required on Windows as Linux and Mac usually come with essential CLI-tools preinstalled)
   - [GIT](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
   - [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
   - [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
     - Install the required Ansible-Docker module by running the command [`ansible-galaxy collection install community.docker`](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_compose_module.html)
2. Login to [https://digitalocean.com](https://digitalocean.com)
3. Go to the [Token-Section](https://cloud.digitalocean.com/account/api/tokens) and [create a new Personal Access Token](https://cloud.digitalocean.com/account/api/tokens/new) or regenerate an already existing one which you previously used and have not connected to a active pipeline
4. Take the Token to your clipboard (Crtl+C)
5. Start a Shell inside the folder this document resides in and launch the terraform script with a sequence of the following commands:
   - `terraform init` => Will initialize the neccesarry terraform communication-modules on your system
   - `terraform plan` => Will ask you for your API-Key which you need to provide, this commant will generate a plan on what needs to be done on the cloud plattform to have your required amount of ressources/VMs avaliable
   - `terraform apply -auto-approve` => Will ask you for your API-Key which you then need to provide, this command will run the deployment-command which does the following steps:
     - create a new ephemeral SSH-Key-Pair which will be used to login to the newly created VMs
     * delete old instance of the VM if it is different from the required profile
     * create as many new Projects, Namespaces and VMs as specified based on the available Images of the cloud plattform
     * once the VMs are up, register the SSH-Keys with the new machines
     * in parallel, login to each new machine and start executing the Ansible-Script
6. Go and inspect the newly deployed web-services, for this see [this presentation](https://url.macenka.de/demo_setup)
7. After you are done with experimenting the Webservices, destroy the commissioned machines again with the command `terraform destroy -auto-approve`

# What to do next?

# Links and references