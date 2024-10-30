---
title: Use Ventoy on any Windows System
date: 2024-10-30 20:00:00 +0200
categories: [Tutorials]
tags: [ventoy,operating-system,os,infrastructure]
authors: [jan]
published: true
#pin: true
#comments: false
#mermaid: true
#math: true
---

![Ventoy](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Flinuxiac.b-cdn.net%2Fwp-content%2Fuploads%2F2021%2F03%2Fventoy.png&f=1&nofb=1&ipt=e83763dd73bad04f85d0e8ac9365d0c2bbb570507014064875f2c3ac1b0720ac&ipo=images)

# Using Ventoy to Boot Linux or Windows from USB on Any System

Dear fellow digitalization colleagues,

Ventoy offers a powerful, flexible way to live-boot or install multiple operating systems on almost any hardware. In this tutorial, we’ll introduce Ventoy, walk through preparing a USB stick with it, and cover steps to verify and adjust system compatibility for live booting a Linux OS on Windows devices with BIOS or UEFI requirements.

## What are we going to do?

This guide will cover:
1. A brief introduction to Ventoy.
2. Preparing a USB stick with Ventoy from a Linux system.
3. Loading OS images onto the Ventoy USB stick (Ubuntu, Windows 11, Debian).
4. Steps to ensure compatibility with Secure Boot and TPM settings on Windows.
5. Configuring a one-time reboot directly to BIOS/UEFI for setup without manual intervention.

> This is a **demo setup** and lacks the usual security precautions you’ll need to consider for production! This can be a helpful starting point but is **NOT a production setup**!
{: .prompt-danger }

## Which technologies will we use?

* [Ventoy](https://www.ventoy.net) >> Tool for creating multiboot USB drives with multiple OS images.
* [PowerShell](https://docs.microsoft.com/en-us/powershell/) >> Scripting tool to access Windows settings for BIOS/UEFI checks.
* [Ubuntu ISO](https://ubuntu.com/download), [Windows 11 ISO](https://www.microsoft.com/software-download/windows11), [Debian ISO](https://www.debian.org/distrib/netinst) >> Example operating systems for booting.

# Setup Guide

## Prerequisites

* A USB stick with at least 8 GB of space.
* Access to a Linux system to prepare the USB stick.
* Administrative access to the Windows system for compatibility checks.

## Introduction to Ventoy

Ventoy is an open-source tool that lets you create a multiboot USB drive. Once Ventoy is installed, you can load multiple operating system images (ISOs) onto the USB stick, and Ventoy will detect and allow you to choose any of them on boot. This makes it ideal for live OS testing, troubleshooting, and system installation.

## Preparing a USB Stick with Ventoy (Linux Instructions)

### Step 1: Download Ventoy

On a Linux machine, download the latest release of Ventoy from the [official website](https://www.ventoy.net).

In the terminal:

```bash
# Download the latest Ventoy release
wget https://github.com/ventoy/Ventoy/releases/download/v1.0.80/ventoy-1.0.80-linux.tar.gz
```

### Step 2: Extract the Ventoy Package

Once downloaded, extract the package:

```bash
# Extract the downloaded file
tar -xzf ventoy-1.0.80-linux.tar.gz
cd ventoy-1.0.80
```

### Step 3: Install Ventoy on the USB Stick

**Warning**: This step will erase all data on the USB stick, so make sure you back up any important files.

1. List your storage devices to identify the USB stick. You can use `lsblk` to check the device name:

```bash
lsblk
```

   Find your USB stick’s device name, typically `/dev/sdb` or similar.

2. Run the Ventoy installation command, substituting `/dev/sdX` with your USB stick’s device name:

```bash
sudo ./Ventoy2Disk.sh -i /dev/sdX
```

   - `-i` installs Ventoy on the USB stick.
   - If you need to update an existing Ventoy installation, use `-u` instead.

### Step 4: Verify Installation

Once installed, your USB stick will have a Ventoy partition. You can now copy multiple ISO files to it.

## Adding OS Images to Ventoy USB Stick

After setting up Ventoy, copy your desired ISO files to the USB stick’s main directory. No additional configuration is needed, as Ventoy will recognize these images on boot.

Example ISO files:

1. **Ubuntu**: Download from [Ubuntu Downloads](https://ubuntu.com/download)
2. **Windows 11**: Download from [Windows 11 Downloads](https://www.microsoft.com/software-download/windows11)
3. **Debian**: Download from [Debian Downloads](https://www.debian.org/distrib/netinst)

Place the ISOs in the USB stick's root directory:

```bash
# Example of copying ISO files to the Ventoy USB
cp ~/Downloads/ubuntu-20.04.4-desktop-amd64.iso /media/$USER/Ventoy/
cp ~/Downloads/Win11_English_x64.iso /media/$USER/Ventoy/
cp ~/Downloads/debian-11.2.0-amd64-netinst.iso /media/$USER/Ventoy/
```

## Checking Compatibility on Windows Systems

To boot with Ventoy on Windows devices, it’s essential to verify and adjust Secure Boot and TPM settings. Here’s how to check these from PowerShell:

### Step 1: Check Secure Boot Status in PowerShell

1. **Open PowerShell as Administrator:**
   - Press `Windows + X` and select **Windows PowerShell (Admin)**.

2. **Run the following command to check Secure Boot status:**

    ```bash
    Confirm-SecureBootUEFI
    ```

   - **Output Interpretation**:
     - **True**: Secure Boot is enabled.
     - **False**: Secure Boot is disabled.
     - **Error**: Secure Boot isn’t supported on this hardware.

### Step 2: Check TPM Status in PowerShell

To check if TPM (Trusted Platform Module) is present and enabled, use:

```
Get-WmiObject -Namespace "Root\CIMv2\Security\MicrosoftTpm" -Class Win32_Tpm
```

- If TPM is available, you’ll see details like the manufacturer and version.
- No output means TPM isn’t available on this system.

### Reboot Directly into BIOS/UEFI from Windows

If adjustments to Secure Boot are required or you’d like to avoid pressing keys on boot, use PowerShell to initiate a one-time BIOS/UEFI boot.

1. **Run this command in PowerShell (Admin):**

   ```
   shutdown /r /fw /t 0
   ```

   This command reboots the system directly into BIOS/UEFI for the next startup only.

## What to Do Next?

For a fully functional Ventoy setup:
* Test the USB on your target system to confirm the BIOS/UEFI settings allow booting.
* Secure accounts if using the setup beyond demos.
* Set up automatic backups of Ventoy and ISOs for future use.

# Links and References

- [Ventoy Project Site](https://www.ventoy.net)

Best regards,

[_Jan Macenka_](https://www.macenka.de)
