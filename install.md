Install notes...  works on my machine.

# System overview
* OS: Ubuntu server 23.04
* Hostname: farrt

# .ssh/config on Windows box
```shell
Host farrt
    StrictHostKeyChecking no
    User <user>
    IdentityFile <path-to-private-key>
    UserKnownHostsFile NUL # for windows. w h y c a n t w e h a v e o n e m o r e l ?
    # UserKnownHostsFile /dev/null # for linux
```

Adjust `<user>` and `<path-to-private-key>` to your setup.  Or remove to enter password every login.  Using `IdentityFile` requires the public key to be on the farrt box of course.  Search Google or ask ChatGPT for help.

It may be covenient to add hosts entries to help with local DNS resolution.  Adjust IP to your setup.  For example:
```
192.168.86.50 farrt
```

* Windows -> `C:\Windows\System32\drivers\etc\hosts`
* Linux -> `/etc/hosts`

# Docker testing
## Initial installation, configuration, and testing done with Ubuntu server to Raspberry Pi 4
* Follow these instructions to flash an SD card:
    * [How to install Ubuntu Server on your Raspberry Pi](https://ubuntu.com/tutorials/how-to-install-ubuntu-on-your-raspberry-pi#1-overview)
    * Make sure to use advanced options for headless install.
* After pau, load SD card to Raspberry Pi and power on.
* Wait five minutes before connecting.
* `ssh <user>@farrt`

## Final installation on a [Beelink S12 Pro Mini PC](https://www.amazon.com/gp/product/B0BVLS7ZHP)
* Installed with same Ubuntu server version as Rasperry Pi
* Logged into pre-installed Windows to register Windows license then installed Ubuntu.
* When I was done fiddling with a service on the Raspberry Pi I just zipped up `/mnt/docker/services/<name>` and moved to Mini PC.  Easy.

### Go to your home directoy, then vi `update.sh`, paste in this helper update sacript, then chmod 744, and run `./update.sh`.
```shell
#!/bin/bash

TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[0;33m'
TEXT_GREEN='\e[0;32m'
TEXT_RED_B='\e[1;31m'

echo -e $TEXT_YELLOW
echo '-----------------------------------------------'
echo 'Starting sudo apt-get update...'
echo -e $TEXT_RESET
sudo apt-get update
echo -e $TEXT_GREEN
echo 'sudo apt-get update finished!'
echo -e $TEXT_RESET

echo -e $TEXT_YELLOW
echo '-----------------------------------------------'
echo 'Starting sudo apt-get dist-upgrade...'
echo -e $TEXT_RESET
sudo apt-get dist-upgrade
echo -e $TEXT_GREEN
echo 'sudo apt-get dist-upgrade finished!'
echo -e $TEXT_RESET

echo -e $TEXT_YELLOW
echo '-----------------------------------------------'
echo 'Starting sudo apt-get upgrade...'
echo -e $TEXT_RESET
sudo apt-get upgrade
echo -e $TEXT_GREEN
echo 'sudo apt-get upgrade finished!'
echo -e $TEXT_RESET

echo -e $TEXT_YELLOW
echo '-----------------------------------------------'
echo 'Starting sudo apt-get autoremove...'
echo -e $TEXT_RESET
sudo apt-get autoremove
echo -e $TEXT_GREEN
echo 'sudo apt-get autoremove finished!'
echo -e $TEXT_RESET

if [ -f /var/run/reboot-required ]; then
    echo -e $TEXT_RED_B
    echo 'Reboot required! Run using "sudo reboot now"'
    echo -e $TEXT_RESET
fi

echo -e $TEXT_GREEN
echo 'Pau.  Have a nice day.'
echo -e $TEXT_RESET
```

## Add a Samba network drive to the Synology NAS:

1. Install the necessary packages:
```shell
sudo apt update && sudo apt install cifs-utils
```

2. Create a directory where you want to mount the Samba network drive for the data:
```shell
sudo mkdir /mnt/data
```

3. Open a text editor with administrative privileges to create a credentials file that will store the Samba login information:
```shell
sudo mkdir /etc/samba && sudo vi /etc/samba/credentials
```

4. In the text editor, add the following lines, replacing `USERNAME` and `PASSWORD` with your Samba login credentials:
```shell
username=USERNAME
password=PASSWORD
```

5. Save/Exit the text editor.

6. Secure the credentials file by restricting access to the root user only:
```shell
sudo chmod 600 /etc/samba/credentials
```

7. Open the `/etc/fstab` file:
```shell
sudo vi /etc/fstab
```

8. Add the following to define the mount point for the Samba data network drive, edit `NAS-NAME-OR-IP`:
```shell
//NAS-NAME-OR-IP/data /mnt/data cifs credentials=/etc/samba/credentials,iocharset=utf8,gid=1003,uid=1000,file_mode=0777,dir_mode=0777 0 0
```

9. Save/Exit the editor.

10. Mount the Samba network drive:
 ```shell
sudo systemctl daemon-reload && sudo mount -a
 ```

11. You should now be able to access the Samba network drive at `/mnt/data`.

Create the Docker app directory and folders and assign privs to your user and group:
```shell
sudo mkdir /mnt/docker /mnt/docker/services && cd /mnt/docker/services
```
```shell
sudo mkdir bazarr diun duckdns emby homepage jellyseerr prowlarr radarr sabnzbd sonarr swag transmission-openvpn transmission-rush
```
```shell
sudo chown -R <user>:<group> /mnt/docker/services
```

We do not put the Docker services folders on the NAS.  Some services may behave oddly.

Need a username and group?  Try use `festerhead:iscool`, can't go wrong.

Find out your `uid` and `pid` to use in the `.env` file:
```shell
id
```
```shell
# portion of the output for username festerhead and group iscool
uid=1000(festerhead) gid=1003(iscool)
```

## Install Docker
See: https://www.cloudbooklet.com/how-to-install-docker-on-ubuntu-22-04/ (Or see any other search result)

Start by updating the packages to the latest version available.
```shell
sudo apt update && sudo apt upgrade
```

### Install Docker
Install some packages which allows you to use the packages over HTTPS.
```shell
sudo apt install apt-transport-https ca-certificates curl software-properties-common
```

Add the GPG key of Docker repository.
```shell
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

Add the Docker repository to the apt sources.
```shell
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Update the packages index and setup your server to install Docker from official Docker repo.
```shell
sudo apt update && sudo apt-cache policy docker-ce
```

You'll see something like:
```shell
#Sample output, Ubuntu version name can differ
docker-ce:
  Installed: (none)
  Candidate: 5:24.0.2-1~ubuntu.23.04~lunar
  Version table:
     5:24.0.2-1~ubuntu.23.04~lunar 500
        500 https://download.docker.com/linux/ubuntu lunar/stable arm64 Packages
     5:24.0.1-1~ubuntu.23.04~lunar 500
        500 https://download.docker.com/linux/ubuntu lunar/stable arm64 Packages
     5:24.0.0-1~ubuntu.23.04~lunar 500
        500 https://download.docker.com/linux/ubuntu lunar/stable arm64 Packages
     5:23.0.6-1~ubuntu.23.04~lunar 500
        500 https://download.docker.com/linux/ubuntu lunar/stable arm64 Packages
     5:23.0.5-1~ubuntu.23.04~lunar 500
        500 https://download.docker.com/linux/ubuntu lunar/stable arm64 Packages
     5:23.0.4-1~ubuntu.23.04~lunar 500
        500 https://download.docker.com/linux/ubuntu lunar/stable arm64 Packages
     5:23.0.3-1~ubuntu.23.04~lunar 500
        500 https://download.docker.com/linux/ubuntu lunar/stable arm64 Packages
```

#### Really Install Docker.
```shell
sudo apt install docker-ce && sudo systemctl enable docker && sudo systemctl status docker
```

Configure sudo permissions for Docker
```shell
sudo usermod -aG docker <username>
```

Now restart your SSH or open a new terminal to see the changes.
```shell
docker --version
```

Try it out:
```shell
docker run hello-world
```
```shell
# Sample output
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

## Install Docker Compose
install latest version of Docker Compose from the official GitHub repository.

See: https://github.com/docker/compose/releases for latest release number
```shell
sudo curl -L https://github.com/docker/compose/releases/download/v2.18.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
```

Set up correct permissions to the downloaded file.
```shell
sudo chmod +x /usr/local/bin/docker-compose
```

Verify the installation
```shell
sudo docker-compose --version
```
```shell
# Sample output
Docker Compose version v2.18.1
```

Create your own .env file.  It should be in the same folder as docker-compose.yaml such as `/mnt/projects/FARRT`. My file is not committed to this respository. When you see something like `${SERVICE_DIR}` in `docker-compose.yaml` the reference is in this `.env` file.  Here is what I use with sensitive data redacted:
```shell
# OpenVPN Configuration
# Figure out what works best for you.  PIA for life amen.
OPENVPN_PROVIDER=PIA
OPENVPN_CONFIG=******
OPENVPN_USERNAME=******
OPENVPN_PASSWORD=******

# LAN network IP range
# Figure out what works best for you
LOCAL_NETWORK=192.168.86.0/24

# Directories for container configs and media data
# Figure out what works best for you
SERVCICE_DIR=/mnt/docker/services    # This should be a folder on the host; do not use a NAS mount
DATA_DIR=/mnt/data                   # This can/should be a NFS or Samba NAS mount

# User/Group ID, umask, and timezone for almost all containers
# Figure out what works best for you
PGID=1003
PUID=1000
UMASK=022
TZ=Pacific/Honolulu

# Slack notification hook ID
# Read the docs to get yer own ID
SLACK_HOOK=******

# Duck DNS
DUCKDNS_SUBDOMAINS=******
DUCKDNS_TOKEN=******

# SWAG configuration
# Figure out what works best for you
SWAG_SUBDOMAINS=www,
SWAG_VALIDATION=http
SWAG_URL=******
SWAG_EMAIL=******
SWAG_EXTRA_DOMAINS=******
```

## Install services
```shell
docker-compose pull <name>
docker-compose up -d <name>
```

Highly recommend to install one service at a time.

See also: `helpful-commands.md`

If need to change service:
```shell
docker stop <name>
docker rm <name>
```

## Services on LAN IP or subdomains or subfolders
Ways to access the services:
### LAN IP
`http://farrt:<port>`

This is what you get out of the box.  Sevices are only accessible internally and using the ports.

### Subdomains
`https://<service>.<domain>.<ext>`

Typically means adding the service as a CNAME to DNS and Let's Encrypt then moving one of the `<service>.subdomain.conf.sample` files in `/mnt/docker/services/swag/nginx/proxy-confs` into place.

### Subfolders
`https://www.<domain>.<ext>/<service>`

No extra DNS or SSL configuration required.  Move one of the `<service>.subfolder.conf.sample` files in `/mnt/docker/services/swag/nginx/proxy-confs` into place.

Whatever you choose, use strong usernames and passwords.  Using a password manager tool means you don't have to remember [version 4 UUID](https://www.uuidgenerator.net/) usernames and passwords.

Also, you can add allow/block directives to the server or location blocks.  To restrict access to only machines on a local LAN IP range of 192.168.86.0/24 use:
```shell
    allow 192.168.86.0/24;
    deny all;
```

Find out what works for you.

# Service configuration
In order to have a portable configuration, recommend to use the following:
* `http://localhost:<port>` for services to contact themselves
* `http://<service>:<port>` for services to contact other services internally, such as `http://radarr:7878`
* `http://fart:<port>` to connect to services from LAN IPs

Moving one, more, or all Docker services to a different machine on the same LAN IP is 'easy'.  Make a zip of `/mnt/docker/services` and unzip on the new target using the same path.

# Helpful script to update a Docker service
See `dc-update.sh` for a useful script to update Docker services.

I use `diun` to post a notice to Slack every Wednesday 3pm server time for all containers that need an update.  It's a nice wrapper for `docker-compose pull` and `docker-compose up -d`.  I have no desire to automate service updating.
