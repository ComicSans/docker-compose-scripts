# Home Automation Docker Stack

## Directory structure

The script needs these folders: 
```
backups (backups are saved here)
configs (mounted to docker container)
docker-compose (list of docker compose files)
```

## Mount network shares

You can use a network mounted volume to have a backup. Edit /etc/fstab and add:

```
//<network ip>/<shared folder> <path to local folder> cifs credentials=<path to credentials>/.smbcredentials,x-systemd.automount,iocharset=utf8,rw,uid=1000,gid=1000,vers=3,nobrl 0 0
```

## Local Setup

* http://192.168.178.1 Fritzbox (DHCP server and internet gateway)
* http://192.168.178.195:8765 MotionEye - camera recorder
* http://192.168.178.196 deCONZ - used with a ConBee III stick for zigbee
* http://192.168.178.197:8123 Home Assistant - the main home assistant application
* http://192.168.178.198 RaspberryMatic - local Homematic IP 
* http://192.168.178.199 PiHole - local DNS server with ad block

## Helper Scripts

### Run a container from a docker-compose file:

```
cd docker-compose
./run_container.sh <name of docker-compose file>
```

### Create macvlan  network interfaces

To create a macvlan for your docker containers and register an interface shim on the host
simply run this script:
```
./create_vlan.sh
```
Please note that your DHCP server should not hand out IPs above 192.168.178.190 as the 
docker compose files have an ip address explicitly set (starting with 192.168.178.195).
The shim will have 192.168.178.223, gateway ist set to 192.168.178.1 (FritzBox default).

### Make backups

This shell script will stop all running containers, tar zip all data and config files
and save the result in the backups directory. The file will be named as the current date
(day only, no timestamp):
```
./run_backups.sh
```

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

