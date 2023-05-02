
# amcat4docker

![flow](amcat-flow-docker.drawio.svg)

To run `Elasticsearch`, `amcat4` and `amcat4client` (the amcat web interface) from docker, download the [docker-compose.yml file](https://raw.githubusercontent.com/JBGruber/amcat4docker/main/docker-compose.yml) or clone the repository to build the images yourself.
For more information about AmCAT, see the [amcat manual](https://amcat-book.netlify.app/).

# Usage
## From dockerhub

Download the prebuild images from our [dockerhub repository](https://hub.docker.com/u/ccsamsterdam) and start the containers:

``` bash
wget https://raw.githubusercontent.com/JBGruber/amcat4docker/main/docker-compose.yml
docker-compose up --pull="missing" -d
```

This pulls the most recent stable images (if it's not already on your machine).
If you want to pull and run the most recent nightly builds of the images instead (which are potentially unstable), use:
<!--  It would be easier to use `docker-compose -f docker-compose-nightlies.yml up --pull="always" -d`, but this does not pull the newest nightlies for some reason -->

``` bash
wget https://raw.githubusercontent.com/JBGruber/amcat4docker/main/docker-compose-nightlies.yml
docker-compose -f docker-compose-nightlies.yml up --pull="missing" -d
```

If you plan to make your amcat instance available via the internet, you should use secure https connections.
We have a separate compose file for that purpose:

``` bash
wget https://raw.githubusercontent.com/JBGruber/amcat4docker/main/docker-compose-https.yml
```

You need to edit the docker-compose-https.yml file and replace example.com in the amcat4_server_name variable before you spin up the containers.

``` bash
docker-compose -f docker-compose-https.yml up --pull="missing" -d
``` 

To obtain the certificates for your website, you can then run:

``` bash
docker exec -it ngincat certbot --nginx -d example.com -d www.example.com
```

(Obviously, you should replace the actual name of your website in the compose file and the end of this command.)
This will only work if your domain is already accesible via the web, otherwise the code challange will fail.
Note that in the https version of the compose file, the nginx configuration is saved in a persistent docker volumne and is not overwritten by restarting or even recreating the container.
To reset your changes to the template, you need to remove the volumne with `docker volume rm amcat4docker_nginx-volume` to return to the default configuration.

## Build Yourself

1. Clone the repository and navigate to folder:

``` bash
git clone https://github.com/JBGruber/amcat4docker.git
cd amcat4docker
```

2. Build without caching to pull the newest version of all packages from GitHub:

``` bash
docker-compose down && \
  docker-compose build --no-cache && \
  docker-compose up -d
```

You can do the same for one of the other Compose files, e.g., `docker-compose-https.yml`:

``` bash
docker-compose -f docker-compose-https.yml down && \
  docker-compose -f docker-compose-https.yml build --no-cache && \
  docker-compose -f docker-compose-https.yml up -d
```

# Configure

The default setting of amcat is to not require any authentication, so you can immediately access it at <http://localhost>.

Of course, this new instance is still completely empty, so there is little to see. If you want to add some test data, you can use the create-test-data command, which will upload some State of the Union speeches:

``` bash
docker exec -it amcat4 amcat4 create-test-index
```

If you want to change the configuration, for example to require authentication, you can run the interactive configuration
(note that you usually need to restart the amcat4 container to load the new settings):

```bash
docker exec -it amcat4 amcat4 config
docker restart amcat4
```

# A quick test

See if documents can be queried from the test index:

```
docker exec -it amcat4 amcat4 create-test-index
curl -s http://localhost/amcat/index/state_of_the_union/documents | head -c 150
```

# Upload to dockerhub (for Contributors)

``` bash
docker image push --all-tags ccsamsterdam/amcat4 && \
  docker image push --all-tags ccsamsterdam/amcat4client && 
  docker image push --all-tags ccsamsterdam/ngincat
```
