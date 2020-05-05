# setup-linux-server
for docker rails project in bionic system


## check os
cat /etc/os-release


## gen ssh
https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account

## setup docker
```
sudo apt-get update
sudo apt-get remove docker docker-engine docker.io
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
docker --version
```

### Got permission denied while trying to connect to the Docker daemon socket
```
sudo groupadd docker
sudo usermod -aG docker ${USER}
su -s ${USER}
docker ps -a
```
## install docker-compose
```
sudo apt install docker-compose
```

## install yarn packages
```
docker-compose run --rm app_name bash
yarn install --check-files
```

## update docker-compose with nginx-proxy & letsencrypt
## allow host
```
config.host << "..."
```

## logs
```
docker-compose logs -f service_name
eg: docker-compose logs -f sidekiq
```

## Dockerfile to build production image
[Dockerfile](https://github.com/radinreth/setup-linux-server/blob/master/Dockerfile)

### build image
```
docker build -t radinreth/mapping-115:0.0.1 .
```
### push image to docker hub
```
docker push radinreth/mapping-115:0.0.1
```

## puma needs
```
mkdir /tmp/pids
```

## postgres database url
DATABASE_URL=postgres://postgres:xxx@db/mapping_115

## Things to keep in mind

- remove old image if necessary
- [update docker-compose.prod.yml](https://github.com/radinreth/setup-linux-server/blob/master/docker-compose.prod.yml)
- [docker-compose.dev.yml](https://github.com/radinreth/setup-linux-server/blob/master/docker-compose.dev.yml)
