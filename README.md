
# Docker compose file and docker containers for AmCAT4

This repository contains a `docker-compose.yml` file for running AmCAT4. 
It is setup to allow both local development/testing use as well as production setup.

## Usage

**Step 0:** Install docker and docker-compose

See the [official docker documentation](https://docs.docker.com/compose/install/) and/or their [specific instructions for linux](https://docs.docker.com/compose/install/linux/). 

**Step 1:** Clone the repository

```{sh}
git clone https://github.com/ccs-amsterdam/amcat4docker
cd amcat4docker
```

**Step 2:** Launch the docker

```{sh}
docker compose up -d
```
Note: You might need to use `sudo docker` and/or `docker-compose` instead of `docker compose` depending on your installation. 

In the default configuration, the web interface should now be available at [http://localhost](http://localhost). On a server, you can test with:

```{sh}
curl localhost/amcat
```

Note that it might take about a minute to boot everything up, so if you don't see anything wait a second and refresh. 

## Configuring AmCAT

The configuration of AmCAT4 is controlled through a `.env` file, for which [an example](.env.example) is given in this repository.

Especially for production use (i.e. on a server accessible to your lab or the world), be sure to edit at least the hostname, cookie secret, authentication, and data storage.

To edit the configuration, copy `.env.example` to `.env` and edit it:

```{sh}
cp .env.example .env
nano .env
```

After editing, either restart individual containers or just run 

```{sh}
docker compose down
docker compose up -d
```

## Troubleshooting

If it doesn't work, check whether all containers are running with 

```{sh}
docker ps
```

To see the logs for a specific container, e.g. amcat4, run:

```{sh}
docker logs -f amcat4
```

# Container overview

AmCAT consists of four main services:

![flow](amcat-flow-docker.drawio.svg)

- amcat4client is the main web UI, based on [ccs-amsterdam/amcat4client](https://github.com/ccs-amsterdam/amcat4client)
- amcat4 is the backend/API, based on [ccs-amsterdam/amcat4](https://github.com/ccs-amsterdam/amcat4) 
- an elasticsearch database is used to store and index the documents
- a 'caddy' web server exposes the client and api so they can be reached on localhost (default) or using an external domain name. 
  
For more information about AmCAT, see the [amcat manual](https://amcat-book.netlify.app/).

# Building your own images

To build the images without caching to pull the newest version of all packages from GitHub:

``` bash
docker-compose down && \
  docker-compose build --no-cache && \
  docker-compose up -d
```

# Upload to dockerhub (for Contributors)

If you've made changes to amcat4 or amcat4client and wish to update the images on docker hub, run `docker login` and then:

``` bash
docker image push --all-tags ccsamsterdam/amcat4 && \
  docker image push --all-tags ccsamsterdam/amcat4client && 
  docker image push --all-tags ccsamsterdam/ngincat
```
