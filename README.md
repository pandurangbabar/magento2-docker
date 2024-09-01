# Install Magento 2 using Docker 

I assume you have installed **Ubuntu 24.04 LTS** OS on your computer. 

I installed and tested this repository for the **Magento 2.4.7-p1** version.

## About me ##
I am a Magento 2 developer with 10+ years of experience in Magento 2, PHP, JavaScript, CSS, and MySQL. Please feel free to contact me, if you need Magento 2 development help.

* Email - pandurangmbabar5@gamil.com
* Skype - live:pandurang.babar

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

## 2. Install Mkcert  ##
> [!NOTE]
> required for https url
 1. Install the required packages
```
apt-get install wget libnss3-tools
```
2. Download the latest version of Mkcert from Github.
 ```
wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64
```
3. Move the downloaded binary to the system path.
```
mv mkcert-v1.4.3-linux-amd64 /usr/bin/mkcert
```
```
chmod +x /usr/bin/mkcert
```
4. Generate Local CA.
```
mkcert -install
```
5. Generate a Certificate for Local Website.
   ```
   mkcert local.m2docker localhost 127.0.0.1 ::1
   ```
6. Copy certificates in the folder .docker/ssl and rename them as cert.pem cert-key.pem 

## 3. Take a clone of the Magento 2 Docker repository ##
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

## 4. Create docker environment ##
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
![1](https://github.com/pandurangbabar/magento2-docker/assets/59949205/55d15688-df65-43f2-985c-be49655da3ab)

The Apache web server is running at http://localhost/
  ![1](https://github.com/pandurangbabar/magento2-docker/assets/59949205/29be9257-7ffe-4a49-91b8-e3bf1fae9892)

PHPMyAdmin is running at http://localhost:8080/
     ![mysql](https://github.com/pandurangbabar/magento2-docker/assets/59949205/90df2865-55e6-4300-beee-c55fd750c4ca)

Opensearch is running at http://localhost:9200/
 ![1](https://github.com/pandurangbabar/magento2-docker/assets/59949205/74316423-3e54-4c86-aa3e-0826cb6cbad9)
> [!NOTE]
> If the opensearch search is not working, please check and set permissions using the below commands.
You can use the below commands to set permissions for the folder.
```
sudo chmod -R 777 magento2-docker
sudo chown -R $USER:$USER magento2-docker
```
Now our Magento 2 development environment is ready. Now we will install Magento 2.
## 5. Install Magento 2 ##
   1. Go to the web container using the below command
```
sudo docker exec -it web /bin/bash
sudo rm -rf src/index.php
```
   2. Get magento metapackage using the below command
```
 composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition:2.4.7-p1 .
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
5. Install Magento using the below command
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
## 6. Test frontend and backend ##
* Frontend URL - http://localhost/
* Backend URL - When installation complete copy backend url from screen

Thank You.
