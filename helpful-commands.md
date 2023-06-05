# Helpful Commands

## Docker commands
[Overview of docker compose CLI](https://docs.docker.com/compose/reference/)
[Use the Docker command line](https://docs.docker.com/engine/reference/commandline/cli/)
### Docker ino:
```shell
docker info
```
### Update all docker images:
```shell
docker-compose pull
```
### Update a single service:
```shell
docker-compose pull <service-name>
```
### Update all services:
```shell
docker-compose up -d
```
### Update a single service:
```shell
docker-compose up -d <service-name>
```
### Prune dangling images:
```shell
docker image prune
```
### List all the running services:
```shell
docker ps -a
```
### Remove all stopped services:
```shell
docker system prune
```
### Remove a specific service:
```shell
docker rm <name>
```

### Stop all services:
```shell
docker stop $(docker ps -q)
```

### Check transmission-openvpn container is using the VPN:
```shell
docker exec transmission-openvpn curl -s https://ipinfo.io/json
```

### Use transmission-openvpn VPN for other containers
* Set the following parameters (after `restart` is a good place) such as:
```shell
    restart: always
    network_mode: "service:transmission-openvpn"
    depends_on:
        - transmission-openvpn
```
* Then check that the service is going through the VPN:
```shell
docker exec <service-name> curl -s https://ipinfo.io/json
```

Test NGINX and reload:
```shell
docker exec -it swag nginx -t
docker exec -it swag nginx -s reload
```

## For all LinuxServer.io containers

### Shell access: 
```shell
docker exec -it <service-name> /bin/bash
```
### Monitor logs:
```shell
docker logs -f <service-name>
```
### Container version number:
```shell
docker inspect -f '{{ index .Config.Labels "build_version" }}' <service-name>
```
### Image version number:
```shell
docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/<service-name>:latest
```
