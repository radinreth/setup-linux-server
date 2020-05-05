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



- remove old image if necessary

## logs
```
docker-compose logs -f service_name
eg: docker-compose logs -f sidekiq
```
