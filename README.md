# Install Magento 2 using Docker 

I assume you have installed **Ubuntu 24.04 LTS** OS on your computer. 

I installed and tested this repository for the **Magento 2.4.8** version.

## About me ##
I am a Magento 2 developer with 10+ years of experience in Magento 2, PHP, JavaScript, CSS, and MySQL. Please feel free to contact me, if you need Magento 2 development help.

* Email - pandurangmbabar5@gamil.com

## 1. Docker and Docker-Compose ##
   1. First, we must install docker and docker-compose on your Ubuntu machine. If docker and docker-compose are not installed on your device, please use the steps below to install them.
   2. Update the apt package index and install packages to allow apt to use a repository over HTTPS
```
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
```
   3. Add Docker’s official GPG key
```
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```
   4. Use the following command to set  the repository.
```
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$UBUNTU_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
   5. Update the apt package index
```
sudo apt-get update
```
   6. Install docker-engine
```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
   7. Verify that the Docker Engine installation
```
sudo docker run hello-world
```
   8. For more information on how to install the Docker engine on Ubuntu use this link.
<br/>https://docs.docker.com/engine/install/ubuntu/<br/>https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

## 2. Take a clone of the Magento 2 Docker repository ##
   1. Take a clone of the Magento 2 Docker repository from  
https://github.com/pandurangbabar/magento2-docker
 
Use the below command to take a clone.
```
git clone https://github.com/pandurangbabar/magento2-docker.git
```
> [!IMPORTANT]
> Check the permission of folder “magento2-docker”. We need read-write permission for the folders dbdata and src.

2. You can use the below commands to set permissions for the folder.

```
sudo chmod -R 777 magento2-docker
sudo chown -R $USER:$USER magento2-docker
```

## 3. Create docker environment ##
   1. If you have installed apache2 and MySQL on your system, then we need to stop both services. We need to stop these services because there will be a port conflict when we run these services using a docker container. Please use the below commands to stop the apach2 and mysql service.
```
sudo service mysql stop
sudo service apache2 stop
sudo service nginx stop
```

   2. Make sure the docker service is started using the command.
```
 sudo service docker status
```
If it is not started start the service using the command.
```
sudo service docker start
```
   3. Go to the repository magento2-docker and execute the below command
```
cd magento2-docker

sudo docker compose up --build -d

```
![docker-compose-up-d](https://github.com/pandurangbabar/magento2-docker/assets/59949205/abfc913a-c706-4069-85cb-448ebfc5a362)

We can use 
```
sudo docker compose down
```
Stops running containers without removing them. They can be started again with 
```
sudo docker compose start
```
```
sudo docker compose down

```
Stop and remove all containers.
  

4. We can make sure all the containers are running fine using the command
```
sudo docker ps

```
![dockerps](https://github.com/user-attachments/assets/c775052d-bed6-4d40-bd59-97c059e79644)


The Apache web server is running at http://localhost/
  ![php](https://github.com/user-attachments/assets/aacaf26a-6eb9-4d79-ba6e-731ca5d3da01)


PHPMyAdmin is running at http://localhost:8080/
     ![mysql](https://github.com/pandurangbabar/magento2-docker/assets/59949205/90df2865-55e6-4300-beee-c55fd750c4ca)

Opensearch is running at http://localhost:9200/
 ![Opensearch](https://github.com/user-attachments/assets/90b1d321-6a8b-46eb-9456-1d16c698c12d)

> [!NOTE]
> If the opensearch search is not working, please check and set permissions using the below commands.
You can use the below commands to set permissions for the folder.
```
sudo chmod -R 777 magento2-docker
sudo chown -R $USER:$USER magento2-docker
```
Now our Magento 2 development environment is ready. Now we will install Magento 2.
## 4. Install Magento 2 ##
   1. Go to the web container using the below command
```
sudo rm -rf src/index.php
sudo docker exec -it web /bin/bash

```
   2. Get magento metapackage using the below command
```
 composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition:2.4.8 .
``` 
  3. When prompted, enter your Magento authentication keys. For more information check this URL https://devdocs.magento.com/guides/v2.3/install-gde/.html
  4. Set file permissions using the below commands
```
cd /var/www/html
find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
chown -R :www-data . # Ubuntu
chmod u+x bin/magento
```
### Set Opensearch 
```
php bin/magento config:set catalog/search/opensearch_server_hostname opensearch-node1
php bin/magento config:set catalog/search/opensearch_server_port 9200
php bin/magento cache:flush
```
### Set Base url 
```
SELECT * FROM `core_config_data` WHERE `path` LIKE '%base_url%';
UPDATE core_config_data SET value = 'http://localhost/' WHERE path = 'web/unsecure/base_url';
UPDATE core_config_data SET value = 'http://localhost/' WHERE path = 'web/secure/base_url';
```
5. Install Magento using the below command
> [!NOTE]
> If you want to install sample data, please run below command before Magento 2 installation.

```
bin/magento sampledata:deploy

```
```
php bin/magento setup:install \
--base-url=http://localhost \
--db-host=db \
--db-name=magento \
--db-user=magento \
--db-password=magento \
--admin-firstname=pandurang \
--admin-lastname=babar \
--admin-email=pndurangmbabar5@gmail.com \
--admin-user=admin \
--admin-password=admin@123 \
--language=en_US \
--currency=USD \
--timezone=America/Chicago \
--use-rewrites=1 \
--search-engine=opensearch \
--opensearch-host=opensearch-node1 \
--opensearch-port=9200 \
--opensearch-index-prefix=magento2 \
--opensearch-timeout=15
```
6. Disable Two factor Authentication module in Magento
```
php bin/magento module:disable Magento_AdminAdobeImsTwoFactorAuth 
php bin/magento module:disable Magento_TwoFactorAuth
php bin/magento cache:flush 
```

7. Run below commands.
```
php bin/magento cache:flush
php bin/magento deploy:mode:set developer
php bin/magento setup:upgrade
php bin/magento setup:di:compile
php bin/magento setup:static-content:deploy -f
php bin/magento indexer:reindex

```
Now magento installation is complete.
## 5. Test frontend and backend ##
* Frontend URL - http://localhost/
* Backend URL - When installation complete copy backend url from screen

##  Help to fix issues ##
> [!NOTE]
If you have installed multiple Magento 2 projects using this docker repository. Use below commands to stop current project start new project.
1. Stop current project
```
docker compose down

```
2. Start new project
```
docker compose build --no-cache
docker compose up -d

```
####  Fix openserach issue ####
> [!NOTE]
if you get issue : No alive nodes found in your cluster
- Check openserach node is running by usig below command
```
docker ps

```
- Check docker container log
  
  ```
docker logs opensearch-node1

```

- Check opensearch is running

```
curl -XGET 'https://localhost:9200/_cluster/health?pretty'

```

- Delete opensearch vloumes

```

docker compose down
docker volume ls
docker volume rm magento2-docker_opensearch-data1
docker volume rm magento2-docker_opensearch-data2

```

Thank You.
