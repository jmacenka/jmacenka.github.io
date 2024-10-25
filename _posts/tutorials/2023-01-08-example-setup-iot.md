---
# tutorial: https://chirpy.cotes.page/posts/write-a-new-post/
title: IoT Example Setup
date: 2023-01-19 14:34:00 +0200
categories: [Tutorial]
tags: [iot,iac,automation,nodered,influxdb,grafana,ansible,terraform]     # TAG names should always be lowercase
authors: [jan]
#pin: true
#comments: false
#mermaid: true
#math: true
---

![](https://ibm.github.io/cloud-enterprise-examples/static/ced342e4102a26420170f80f60846589/1ec2b/IaC-Ansible_Design_1.png)
<!-- ![](https://cloud.macenka.de/core/preview?fileId=468270&x=1920&y=1080&a=true) -->
# IoT Example Setup with Node-Red + InfluxDB + Grafana alongside automated CD pipeline utilizing Ansible + terraform

Dear fellow digitalization colleagues,

when dealing with digitalization in the sense of IoT in an industrial environment, you probably at some point come across the [Node-Red](https://nodered.org/) / [InfulxDB](https://www.influxdata.com/) / [Grafana](https://www.influxdata.com/) setup. At least this was the case for me as of 2022.

I did so as well and will describe to you my journey together with some added code and snippets for building deployment pipelines that you can take as a starting point for your journey.

Please be aware that **this is NOT AT ALL a production ready setup** and intentionally leaves out all usual security-preconsiderations as there is no one size fits all solution. Hence we will deploy our resources in an INSECURE WAY that you definitely would want to adapt if you would like to utilize this setup in an production environment.

Also we wont take any data-backup considerations but if you would like to get an idea of how to backup a generic dockerized payload in a simplistic way, you might start [with this script as a reference](https://git.macenka.de/jan/netbox-docker-with-backup/src/branch/release/backup_netbox_data_folders.sh).

## What are we going to do?

Here is a slide-show with some introduction on the utilized technologies and the setup. 

<style>
.responsive-wrap iframe{ max-width: 100%;}
</style>
<div class="responsive-wrap">
<iframe src="https://docs.google.com/presentation/d/1i8PHt4DJcksrULs_LGcOQLSOkEoK9P1on1qUvryFoU8/embed?start=false&loop=true&delayms=60000" frameborder="0" width="960" height="569" allowfullscreen="true" mozallowfullscreen="true" webkitallowfullscreen="true"></iframe>
</div>

Please note that:

> This is a **demo-setup** and it lacks any of the usual security precautions because you really need to think about them for yourselves! This can be taken as a starting point but is **NOT a production setup**!
{: .prompt-danger }

> This setup was **developed for a manual showcase**, so some of the finishing **setup steps are left to be done manually** on purpose. Because if its just a one-liner Shell-command the intended audience wont really get a grasp of the deployed systems.
{: .prompt-info }

On a high level view we will do the following:

1. Prepare your control-machine with the necessary packages to deploy the environment
2. Create an account at DigitalOcean, which will serve as our cloud to deploy our resources to. If you feel like it, go ahead and deploy onto your own cloud like VMWare-ESXi or Proxmox or what ever hypervisor-System you are using
3. Clone and modify a Repository containing an example setup
4. Deploy the payloads to our could-environment
5. Visit the services and to some post-installation steps which intentionally where left non-automated
6. Inspect the configured Data-Stream which subscribes to a public MQTT-Node that streams data for a weather station utilizing a pre-built Grafana-Dashboard
7. Tear down the entire setup again and if you like to, change/adapt and start the process all over again

## Which technologies will we use?
* [Ansible](https://www.ansible.com/) >> Server configuration management for setting up the new resources
* [DigitalOcean](https://m.do.co/c/a91cfe76d6c0) >> Cloud platform providing compute and storage
* [Docker](https://www.docker.com/) >> Containerization engine
* [docker-compose](https://github.com/docker/compose) >> Container configuration management for smaller projects
* [terraform](https://www.terraform.io/) >> Automated resource provisioning for creating and later tearing down resources in an automated manner

# Setup guide

## Prerequisites

* Have a host- or control-machine where you can install stuff onto
* Have an active internet connection
* Have or register an [account with DigitalOcean](https://m.do.co/c/a91cfe76d6c0) if you want to follow the first step of the example. Feel free to replace it with AWS or your Cloud-Platform of choice.

## Tested with

As of January 2023, I have tested this build with:
* Ubuntu Server 22.04
    * <i class="fa fa-check" aria-hidden="true"></i> VM in [Virtualbox](https://www.virtualbox.org/), [ESXi](https://www.vmware.com/de/products/esxi-and-esx.html) and [Proxmox](https://www.proxmox.com/de/) (without CD-pipeline)
    * <i class="fa fa-check" aria-hidden="true"></i> DigitalOcean [Droplet](https://www.digitalocean.com/products/droplets)

The setup is very stable and the Docker-files are all multi-arch so even running them on top a non x86 machine should work out of the box. Should you encounter problems, feel free to comment below.

## Installation

### Preparations

In this example we will utilize DigitalOcean as Cloud-Provider for our CD-pipeline. For this you [need to register a DigitalOcean account](https://m.do.co/c/a91cfe76d6c0) (feel free to use my referral link).

Go to the [Token-Section](https://cloud.digitalocean.com/account/api/tokens) and [create a new Personal Access Token](https://cloud.digitalocean.com/account/api/tokens/new) or regenerate an already existing one which you previously used and have not connected to a active pipeline. Take note of your Key somewhere or just leave the site open, we will need it later.

Should look like this:
![](/assets/img/screenshots/2023-01-19_19-50_DigitalOcean_Access_Key.png)

### Basic setup

Assuming that you are operating on a system that offers a `bash` Shell environment, start by updating your system and installing the needed dependencies. I am assuming that your system provides a SUDO privilege tool, you can also switch to the root user and omit the `sudo` part of the commands.

First create a place on your system where the source-code will be pulled to:

```shell
mkdir -p ~/apps/example-setup-iot
cd ~/apps/example-setup-iot
```

Install Ansible by following this workflow:

```shell
# Update and install python3 and pip
sudo apt update && sudo apt upgrade -y
sudo apt install python3 python3-pip -y
# Install and upgrade ansible
python3 -m pip install --user ansible
python3 -m pip install --upgrade --user ansible
```
{: file="~/apps/example-setup-iot"}

To install terraform according to the [official documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) like this:

Ensure that your system is up to date, and you have the gnupg, software-properties-common, and curl packages installed. You will use these packages to verify HashiCorp's GPG signature, and install HashiCorp's Debian package repository.

```shell
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
```
{: file="~/apps/example-setup-iot"}

Install the [HashiCorp](https://www.hashicorp.com/security) GPG key.

```shell
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
```
{: file="~/apps/example-setup-iot"}

Verify the key's fingerprint.

```shell
gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint
```
{: file="~/apps/example-setup-iot"}

The gpg command will report the key fingerprint:
(as this was copied form the official documentation, the exact fingerprint might have changed due to update, please refer to [the official documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) to check for genuine installation)

```shell
/usr/share/keyrings/hashicorp-archive-keyring.gpg
-------------------------------------------------
pub   rsa4096 2020-05-07 [SC]
      E8A0 32E0 94D8 EB4E A189  D270 DA41 8C88 A321 9F7B
uid           [ unknown] HashiCorp Security (HashiCorp Package Signing) <security+packaging@hashicorp.com>
sub   rsa4096 2020-05-07 [E]
```
{: file="~/apps/example-setup-iot"}

Add the official HashiCorp repository to your system. The `lsb_release -cs` command finds the distribution release codename for your current system, such as `buster`, `groovy`, or `sid`.

```shell
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
```
{: file="~/apps/example-setup-iot"}

Download the package information from HashiCorp.

```shell
sudo apt update
```
{: file="~/apps/example-setup-iot"}

Install Terraform from the new repository.


```shell
sudo apt-get install terraform
```
{: file="~/apps/example-setup-iot"}

Optionally install the autocomplete package like this and restart your shell session:

```shell
terraform -install-autocomplete
exit 0
```
{: file="~/apps/example-setup-iot"}

### Load Software

Then start a new shell and clone the repository your working directory

```shell
# Clone the repository
cd ~/apps/example-setup-iot
git clone https://git.macenka.de/JanMacenkaITConsulting/example-setup-iot.git .
```
{: file="~/apps/example-setup-iot"}

### Configure Deployment

Move into the deployment directory and run the `terraform init` command to pull the required modules

```shell
cd ~/apps/example-setup-iot/deployment_automation
terraform init
```
{: file="~/apps/example-setup-iot"}

This should output some stdout of your shell telling you that it installed the required modules, somewhat like this:

![](/assets/img/screenshots/2023-01-19_21-03_terraform_init.png)

### Deployment

Next you should be able to run the `terraform plan` command which will ask your DigitalOcean Key that you can copy from the [DigitalOcean control panel webpage](https://cloud.digitalocean.com/account/api/tokens):

```shell
terraform plan
```
{: file="~/apps/example-setup-iot/deployment_automation"}

If successfully, this will output the planning results of what would change on your Cloud-Platform if you would run the `terraform apply` command:

![](/assets/img/screenshots/2023-01-19_21-03_terraform_plan.png)

And running the `terraform apply` command is exactly what we will do next, we also will include the `-auto-approve` flag so we don`t have to re-confirm that we want to apply the changes:

```shell
terraform apply -auto-approve
```
{: file="~/apps/example-setup-iot/deployment_automation"}

this command will run the deployment-command which does the following steps:
* create a new ephemeral SSH-Key-Pair which will be used to login to the newly created VMs
* delete old instance of the VM if it is different from the required profile
* create as many new Projects, Namespaces and VMs as specified based on the available Images of the cloud platform
* once the VMs are up, register the SSH-Keys with the new machines
* in parallel, login to each new machine and start executing the Ansible-Script

### Post deployment configuration

As described the deployment will not do a 100% automated deployment and intentionally leave some steps to be executed manually in the web-interfaces of the applications. For more details see [this presentation](https://url.macenka.de/demo_setup).

Get the public IP (or private IP if you went another way) of the VM/Resource you created on your Cloud-Platform and visit the `http://<YOUR IP Address>:1800` endpoint to check your Node-Red instance as well as the `http://<YOUR IP Address>:3000` for Grafana.

> Please note that while logging in you are shipping your login credentials over an **unencrypted HTTP** connection which is a definite NO-GO for any production environment and **only acceptable for demonstration purposes**.
{: .prompt-danger }

### Guided tour wanted?

Should you be interested in a more guided tour through this Setup, [shoot me an Email](mailto:jan@macenka.de?subject=Requesting%20guided%20tour%20for%20the%20example-setup-iot&body=Dear%20Jan%2C%0D%0A%0D%0AI%20found%20your%20%22example-setup-iot%22%20repository%20and%20tutorial%20and%20would%20love%20to%20get%20in%20contact%20with%20you%20to%20receive%20a%20guided%20tour.%0D%0A%0D%0ACould%20you%20please%20contact%20me%20as%20follows%3A%0D%0A%0D%0A%3C%20YOUR%20CONTACT%20DETAILS%20GO%20HERE%20%3E%0D%0A%0D%0ARegards%2C%0D%0A%3CYOUR%20NAME%3E). I can show to you how you can ingest Sensor-Data and configure SMS-alerts based on dynamic criteria as well as how to inspect and work with your collected data.

### Clean up and tear down

After you are done with experimenting the Web-Services, destroy the commissioned machines again with the command `terraform destroy -auto-approve` which will destroy all the resources defined in the projects terraform-scripts after you confirmed the action with your API Token again:

```shell
terraform destroy -auto-approve
```
{: file="~/apps/example-setup-iot/deployment_automation"}

> Should you forget to destroy your resources, you will be reminded by a large bill at the end of the month ;-)
{: .prompt-warning }

# What to do next?

Some of the thinks you definitely should take care of next are:

* Secure logins and admin-accounts! At least for:
  * [Node-Red](https://nodered.org/docs/user-guide/runtime/securing-node-red)
  * [Grafana](https://de.linuxteaching.com/article/grafana_default_login) (guide in german language, sorry. Try google-translate if needed)
* Take care of TLS which can be achieved with a self-signed certificate or a proper Lets-Encrypt certificate e.g. by utilizing a reverse-proxy like [Nginx-Proxy-Manager](https://nginxproxymanager.com/) or [traefik](https://traefik.io/traefik/). For this see also [the very good tutorial by Techno-Tim on SSL](https://docs.technotim.live/posts/traefik-portainer-ssl/).
* Take care of Backups, you can take [this script](https://git.macenka.de/jan/netbox-docker-with-backup/src/branch/release/backup_netbox_data_folders.sh) as a starting point.
* Experiment with the terraform-scripts that are located under `./deployment_automation` and end with the `.tf` file extension. These are:
  * `droplets.tf` >> Describing the Ressources that will be created on DigitalOcean like Droplets and Namespaces
  * `provider.tf` >> Defines the Cloud-Backend you want to utilize. If you want to exchange this for your local [ESXi](https://github.com/josenk/terraform-provider-esxi) or [Proxmox](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs), feel free to experiment ;-) 
  * `ssh.tf` >> File Describing the ephemeral SSH keys to be generated for login to your machines (at time of writing this is not fully working...)
  * `user_config.yaml` >> A YAML file containing deployment configuration to be provided to DigitalOcean for spinning up the Droplets.
* Understand the Ansible scripts under `./deployment_automation/ansible_playbook_deploy_project.yaml` that take care of the configuration of your resources once these are provisioned using terraform.

# Links and references
- [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [GIT](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [SSH](https://docs.microsoft.com/de-de/windows-server/administration/openssh/openssh_install_firstuse)
- [Presentation Slides](https://url.macenka.de/demo_setup)
- [DigitalOcean](https://digitalocean.com)

Best regards,

[_Jan Macenka_](https://www.macenka.de)