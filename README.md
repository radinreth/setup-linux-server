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


## Issues
### nginx proxy 413 Request Entity Too Large
https://github.com/nginx-proxy/nginx-proxy/issues/690#issuecomment-275560780

### SameSite
https://github.com/rails/rails/pull/28297

## Backup - Dump Database
docker exec -t your-db-container-id pg_dump -h db_hostname -U db_user dbname | gzip > dbname_`date +%Y%m%d"_"%H_%M_%S`.gz
docker exec -t your-db-container-id pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql

ex:

> docker exec -t ab8097e00bd0 pg_dump -h db -U progres mapping-115 > ./backup/mapping-115_`date +%Y%m%d"_"%H_%M_%S`.gz
> 
> docker exec -t ab8097e00bd0 pg_dump -h db -U postgres mapping_115 | gzip > mapping-115_`date +%Y%m%d"_"%H_%M_%S`.gz
> 
> docker exec -t mapping115_db_1 pg_dump -U postgres -d mapping_115 > ./backup/mapping_115_202104221803.sql

## Restore
> gunzip -c dbname_`date +%Y%m%d"_"%H_%M_%S`.gz | docker exec -i your-db-container psql -h db_hostname -U db_user -d dbname

ex:

> gunzip -c mapping-115_20200512_09_50_25.gz | docker exec -i 26ca90b084b4 psql -h db -U postgres -d mapping_115_development -W



 # dump database from AWS RDS
 
 > pg_dump postgres://USERNAME:PASWORD@HOST/DB_NAME -x > chatfuel_production.sql
 
 # VERSION mis-match
 
 [stackoverflow](https://stackoverflow.com/questions/12836312/postgresql-9-2-pg-dump-version-mismatch)
 
 # Source sql to local database
 
 > docker exec -i 9d506f08dc98 psql -h 172.22.0.3 -U postgres chatfuel_dev < chatfuel_production.sql
 9d506f08dc98: db-container-id
 172.22.0.3: inspect db-container-id
 
 ## on staging
 > docker exec -i owso-pea_db_1 psql -U postgres -d chatfuel < path-to-your-file/chatfuel_production-31-aug.sql
 
 > docker inspect 9d506f08dc98
 
 > docker exec -it owso-pea_db_1 psql -U postgres
 
 
 ## Export CSV
 > psql postgres://postgres:path/chatfuel_production -c "Copy (SELECT * FROM voice_messages WHERE (DATE(created_at) BETWEEN '2020/08/28' AND '2021/01/20')) To STDOUT With CSV HEADER DELIMITER ',';" > foo_data.csv

 ## Export 115
docker exec -i mapping115_db_1 psql -U postgres -d mapping_115 -c "Copy (select * from locations) To STDOUT With CSV HEADER DELIMITER ',';" > data.csv

# Mobile
[change app icon](https://medium.com/@ansonmathew/app-icon-in-react-native-ios-and-android-6165757e3fdb)
[change app name](https://stackoverflow.com/questions/34794679/change-app-name-in-react-native)
[apk vs aab explain](https://dev.to/srajesh636/how-we-reduced-our-production-apk-size-by-70-in-react-native-1lci)
[generate apk](https://dev.to/zilurrane/generate-release-mode-apk-for-react-native-project-to-publish-on-playstore-5f78)

./gradlew bundleRelease => generate .aab
./gradlew assembleRelease => generate .apk

## Pull realm db to view mongodb studio
### View filepath
console.log(realm.path)

### login adb as root
adb root

### pull realm file to local dir
adb pull /data/data/{app.identifier.com}/files/default.realm .

### remove realm
adb shell rm /data/data/org.ilabsea.safemigration/files/default.realm
