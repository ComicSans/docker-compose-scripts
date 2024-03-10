# Home Automation Docker Stack

## Installation

SSH into your Raspberry Pi, install git and create a folder for the docker files and scripts:
```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install git

cd ~
git clone https://github.com/ComicSans/docker-compose-scripts.git
cd docker-compose-scripts
mkdir backups
mkdir configs
```

## Directory structure

The script expect some folders: 
```
backups (backups are saved here)
configs (mounted to docker container)
docker-compose (list of docker compose files, you just checked them out in the previous step)
scripts (some scripts to automate tasks)
```

## Local Setup

Network:
http://192.168.178.1 (Fritzbox) DHCP server and internet gateway

Docker: 
* http://192.168.178.195:5000 (Frigate) Camera Recorder
* http://192.168.178.196      (deCONZ) ZigBee hub (used with ConBee III)
* http://192.168.178.197:8123 (Home Assistant) The main home assistant application
* http://192.168.178.198      (RaspberryMatic) local Homematic IP Bridge using an HmIP-RFUSB
* http://192.168.178.199      (PiHole) Local DNS server to clock ads
* http://192.168.178.200      (MariaDB) Database server
* http://192.168.178.201      (Adminer) Database administration

Running on a Raspberry Pi 4 with 8 GB RAM and Debian Bookwom. 

## Helper Scripts

### Run a container from a docker-compose file:

You can see the available docker files in the docker-compose directory.

```
./start.sh <name of docker-compose file>
```

### Create macvlan network interfaces

To create a macvlan for your docker containers and register an interface shim on the host
simply run this script:
```
./create_vlan.sh
```
Please note that your DHCP server should not hand out IPs above 192.168.178.190 as the 
docker compose files have an ip address explicitly set (starting with 192.168.178.195).
The shim will have 192.168.178.223, gateway ist set to 192.168.178.1 (FritzBox default).

### Make backups

This shell script will stop homeassistant and mariadb containers, tar zip all data and config files
and save the result in the backups directory. The file will be named as the current date
(day only, no timestamp):
```
./backup.sh
```
Frigate recordings are not saved.

#### Mount network share

You can use a network mounted volume as backup folder for additional security. 

Create a local folder as mount point (`mkdir /shared/backup`).

Edit /etc/fstab and add:
```
//<network ip>/<shared folder> <path to local folder> cifs credentials=<path to credentials>/.smbcredentials,x-systemd.automount,iocharset=utf8,rw,uid=1000,gid=1000,vers=3,nobrl 0 0
```

Create a file in `~/.smbcredentials` (this will hold your unencrypted password):
```
username=<your smb user name>
password=<your smb password>
domain=WORKGROUP
```

Tell the system to mount the share: `sudo mount -a`.

## Helper applications

### Lazydocker

See [here](https://github.com/jesseduffield/lazydocker). 
```
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
```

### Docker

```
curl -fsSL https://get.Docker.com -o get-Docker.sh
sudo sh get-Docker.sh
sudo usermod -aG docker $USER
newgrp docker
docker run hello-world
```

