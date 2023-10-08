---
# tutorial: https://chirpy.cotes.page/posts/write-a-new-post/
title: Setting Up a Windows 10 Host for Ansible
date: 2023-09-10 20:00:00 +0200
categories: [Tutorials]
tags: [Ansible,Provisioning,Windows,WinRM]     # TAG names should always be lowercase
authors: [jan]
published: true
#pin: true
#comments: false
#mermaid: true
#math: true
---

![Ansible for Windows Automation](https://www.ansible.com/hubfs/2018_Images/Social-Blog/Ansible-Get-Started-Windows.png)

# Setting Up a Windows 10 Host for Ansible

Ansible is a renowned automation tool, which, despite being predominantly linked with Linux, can also manage Windows machines. This guide will walk through setting up a Windows 10 host to communicate with Ansible using WinRM (Windows Remote Management).

## What's the Plan?

- Prepare a Win10 Machine to be configured by Ansible
- Setup the host machine with a basic Ansible script to setup the Win10 machine

> 🔴 **Disclaimer**: This tutorial is for **demonstration purposes only**. 

Security aspects are deliberately minimized for clarity. Always adopt security best practices for production setups.
{: .prompt-danger }

## Assumptions:
- You have a frehsly installed Win10 machine e.g. on your Proxmox host. ISO is Win1022H2 [which you can get here](https://www.microsoft.com/de-de/software-download/windows10ISO).
- Initial installation of Windows is done and you have setup a administrator user account in Offline mode.

## Tools We'll Use:
- [Ansible](https://www.ansible.com/) >> Our automation tool of choice for this task.
 
## Let's Get Started on the Win10 side!

Initially connect to your Win10 Machine. In Proxmox you can use the [NoVNC](https://pve.proxmox.com/wiki/NoVNC) console for this and perform these preparation steps:

## 1. Enable PowerShell Remoting

Firstly, PowerShell Remoting should be activated:

```powershell
Enable-PSRemoting -Force
```

## 2. Install the WinRM Listener

Although Windows 10 has WinRM enabled by default, it doesn’t accept remote connections due to no defined listeners. To create a listener:

```powershell
winrm quickconfig
```

## 3. Configure WinRM Service

Ensure that WinRM is configured to start automatically:

```powershell
Set-Service -Name winrm -StartupType 'Automatic'
Start-Service -Name winrm
```

## 4. (Optional) Allow Unencrypted Traffic

For testing environments without SSL, unencrypted traffic might be permitted, though this is **not recommended** for production use:

```powershell
Set-Item -Path WSMan:\\localhost\\Service\\AllowUnencrypted -Value $true
```

## 5. Set Up Authentication

Choose an appropriate authentication method:

- **Basic Authentication** (simpler but less secure):

  ```powershell
  Set-Item -Path WSMan:\\localhost\\Service\\Auth\\Basic -Value $true
  ```

  Ensure "Allow Basic authentication" is enabled in local or group policy.
  
- **Certificate-based authentication**: This is more secure but comes with additional setup.
  
- **NTLM or Kerberos**: Especially useful if Ansible control machine is domain-connected.

## 6. Firewall Configuration

Allow the Ansible control machine to connect:

```powershell
New-NetFirewallRule -Name "WinRM HTTP" -DisplayName "WinRM HTTP" -Enabled True -Profile Any -Action Allow -Direction Inbound -LocalPort 5985 -Protocol TCP
```

## 7. Adjust Memory and Shell Limits

Prevent task failures due to resource constraints by modifying the WinRM settings:

```powershell
Set-Item WSMan:\\localhost\\Shell\\MaxMemoryPerShellMB 1024
Set-Item WSMan:\\localhost\\Plugin\\Microsoft.PowerShell\\Quotas\\MaxMemoryPerShellMB 1024
```

> 🚫 **Note**: The `ansible_winrm_server_cert_validation=ignore` setting is for bypassing certificate validation. It's for testing purposes only.

With these steps completed, your Windows 10 machine should be ready to be managed by Ansible. Always prioritize security when transitioning from a test to a production environment.

## Lets get started on the Control-Machine side!

On the control machine we want to create a Ansible Script to do some basic installations and configurations. There is a description of what we will setup:

* Create a User with given credentials.
* Update the System to latest status.
* Install Microsoft Teams.
* Install and update Microsoft 365
* Install the following browsers:
  - Chrome
  - Firefox
  - Edge
* Install Adobe PDF Reader

## Project Structure

```plaintext
ansible-win10-setup/
|-- inventory.ini
|-- playbook-win10-configuration.yml
|-- credentials
|-- roles/
    |-- windows-user/
    |-- windows-update/
    |-- tool-installation/
    |-- microsoft-365/
    |-- browsers/
    |-- adobe-reader/
```

start with:

```bash
mkdir ansible-win10-setup
cd ansible-win10-setup
```

## 1. Setting Up the Inventory

Your `inventory.ini` file should look as follows:

```ini
[win10]
<YOUR_MACHIENS_IP>
<CAN_BE_MORE_THAN_ONE>

[win10:vars]
ansible_connection=winrm
ansible_port=5985
ansible_winrm_transport=basic
ansible_winrm_scheme=http
ansible_winrm_server_cert_validation=ignore
```
{: file="./ansible-win10-setup/inventory.ini"}


## 2. Credentials with Ansible Vault

The credentials for the admin user and the new user you wish to create will be stored securely in an Ansible Vault file named `credentials`. Create it with this command:

```bash
ansible-vault create credentials
```

Here's its structure for the files content:

```plaintext
admin_user: your_admin_username
admin_password: your_admin_password
win_username: new_user_name
win_password: new_user_password
```
{: file="./ansible-win10-setup/credentials"}

## 3. windows-user role
This role will create a new Windows user with the provided credentials. Create the file `/roles/windows-user/tasks/main.yml`:

```bash
mkdir -p roles/windows-user/tasks
touch roles/windows-user/tasks/main.yml
```

and fill in this content:

```yaml
---
- name: Create a new user
  ansible.windows.win_user:
    name: "{{ win_username }}"
    password: "{{ win_password }}"
    state: present
```
{: file="./ansible-win10-setup/roles/windows-user/tasks/main.yml"}

## 4. windows-update role
This role will update your system with CriticalUpdates and SecurityUpdates `/roles/windows-update/tasks/main.yml`:

```bash
mkdir -p roles/windows-update/tasks
touch roles/windows-update/tasks/main.yml
```

and fill in this content:

```yaml
---
- name: Ensure Windows is fully updated
  ansible.windows.win_updates:
    category_names: ['CriticalUpdates', 'SecurityUpdates']
    reboot: yes
```
{: file="./ansible-win10-setup/roles/windows-update/tasks/main.yml"}

## 5. Software installation task
This role will make sure Microsoft-Teams, Office365 and AdobeReader are installed on the system. Create the file `/roles/tool-installation/tasks/main.yml`:

```bash
mkdir -p roles/tool-installation/tasks
touch roles/tool-installation/tasks/main.yml
```

and fill in this content:

```yaml
---
- name: Install MS Teams using winget
  ansible.windows.win_shell: winget install Microsoft.Teams

- name: Install Microsoft 365 using winget
  ansible.windows.win_shell: winget install "Microsoft 365"

- name: Install Adobe Reader using winget
  ansible.windows.win_shell: winget install Adobe.Reader
```
{: file="./ansible-win10-setup/roles/tool-installation/tasks/main.yml"}

## 6. Browser installation task
Create another role that will ensure the basic browsers are installed. Create the file `/roles/browsers/tasks/main.yml`:

```bash
mkdir -p roles/browsers/tasks
touch roles/browsers/tasks/main.yml
```

and fill in this content:

```yaml
---
- name: Install Chrome using winget
  ansible.windows.win_shell: winget install Google.Chrome

- name: Install Firefox using winget
  ansible.windows.win_shell: winget install Mozilla.Firefox
```
{: file="./ansible-win10-setup/roles/browsers/tasks/main.yml"}

## 7. The ansible-playbook

Then put everything together in this `ansible-playbook` to execute the job:

```bash
touch playbook-setup-win10.yml
```

and fill in this content:

```yaml
---
- hosts: win10
  vars_files:
    - credentials
  vars:
    ansible_user: "{{ admin_user }}"
    ansible_password: "{{ admin_password }}"
  gather_facts: true
  roles:
    - windows-user
    - windows-update
    - tool-installation
    - browsers
```
{: file="./ansible-win10-setup/playbook-setup-win10.yml"}

## Execute the script

Ensure that the necessary Python package is installed to connect via WinRM from the Ansible machine:

```bash
pip install pywinrm
```

Finally execute the `ansible-playbook` with this command:

```bash
ansible-playbook -i inventory.ini playbook-setup-win10.yml --ask-vault-pass
```
{: file="./ansible-win10-setup/"}

This will prompt you for the vault password you created earlier. Enter it and the playbook will run.
Afterwards you should have a fully configured Windows 10 machine. You can now use this machine as a template for your future Windows 10 VMs.

# Conclusion

This tutorial has shown how to set up a Windows 10 host for Ansible. It's a simple process that can be completed in a few minutes. The next step is to create a playbook that will automate the configuration of your Windows 10 host. This will allow you to easily deploy new hosts with minimal effort.

Best regards,

[_Jan Macenka_](https://www.macenka.de)