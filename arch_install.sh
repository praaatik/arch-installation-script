#!/bin/bash

## networking
# iwctl
# > device list
# > station <device> scan
# > station <device> get-networks
# > station <device> connect <SSID>

## disk formatting
## current setup - 5GB for swap space(/dev/sda1) and rest 290GB (/dev/sda2) for /mnt. 3.1GB backup, do not format this one.
# fdisk -l
# fdisk /dev/sda

## File systems loading
# mkfs.ext4 /dev/sda2
# mkswap /dev/sda1

## Mount the file system
# mount /dev/sda2 /mnt
# swapon /dev/sda1

## installating Arch linux
pacstrap -i /mnt base linux linux-firmware linux-headers

## switch to the base installation
arch-chroot /mnt

## install a bunch of packages
pacman -S vim base-devel openssh
pacman -S networkmanager wpa_supplicant wireless_tools netctl dialog reflector network-manager-applet
pacman -S grub dosfstools os-prober mtools

## enable services
systemctl enable NetworkManager
systemctl enable sshd

## install GRUB
grub-install --target=i386-pc --recheck /dev/sda
mkdir /boot/grub/locale
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
grub-mkconfig -o /boot/grub/grub.cfg


## Fstab file
genfstab -U /mnt >> /mnt/etc/fstab

## Set hardware clock
hwclock --systohc

## Localization
locale-gen

## Update hostname and /etc/hosts file
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts

## Add user
useradd -m -g users -G wheel pratik
# passwd pratik
# pacman -S sudo
# EDITOR=vim visudo and uncomment %wheel ALL=(ALL) ALL

## reboot now
## check wireless connections using nmtui