# Backup

The files in this aspect are scripts that I use for disaster recovery purposes. In addition to making full-disk backups with [Arq](https://www.arqbackup.com/) and [SuperDuper!](https://www.shirt-pocket.com/SuperDuper), I have a number of encrypted volumes on USB sticks that contain critical files that could be used to bootstrap recovery.

## `snapshot`

This one runs from a "master" encrypted volume which I keep as a disk image on my startup disk (but it could be stored on a USB stick; I just keep it on the startup disk so that it is easy to locate the "master" one). It creates a snapshot of critical files in timestamped directories adjacent to the script.

## `sync`

This one also runs from the "master" volume; it's job is to create exact copies of the volume via `rsync` on a number of encrypted USB sticks. In this way if my main machine died, I could use one of the USB sticks to bootstrap a new machine, including creating a new "master" volume if need be.

## `dump-1password`

Creates a JSON dump of everything in my 1Password vaults, and also downloads any documents in the vault. Like the others, this one is intended to be run from an encrypted recovery volume.
