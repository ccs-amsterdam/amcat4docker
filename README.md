
# amcat4docker

![flow](amcat-flow-docker.drawio.svg)

To run `Elasticsearch`, `amcat4` and `nextcat` (the amcat web interface) from docker, download the [docker-compose.yml file](https://raw.githubusercontent.com/JBGruber/amcat4docker/main/docker-compose.yml) or clone the repository to build the images yourself.
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
<-- It would be easier to use `docker-compose -f docker-compose-nightlies.yml up --pull="always" -d`, but this does not pull the newest nightlies for some reason -->

``` bash
wget https://raw.githubusercontent.com/JBGruber/amcat4docker/main/docker-compose-nightlies.yml
docker-compose -f docker-compose-nightlies.yml pull && \
  docker-compose -f docker-compose-nightlies.yml up -d
```

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

# Configure

Before being able to do anything useful through the API, you will need at least one user which can be created with the command below (note, the second `amcat4` is not a typo, but the command, while the first one is the name of the container):

``` bash
docker exec -it amcat4 amcat4 add-admin admin@something.org
docker exec -it amcat4 amcat4 create-env -a admin@something.org -p supergeheim
```

Of course, this new instance is still completely empty, so there is little to see. If you want to add some test data, you can use the create-test-data command, which will upload some State of the Union speeches:

``` bash
docker exec -it amcat4 amcat4 create-test-index
```

After this, you can log into the amcat database using the client at <http://localhost/> [^1] or explore the [R](https://github.com/ccs-amsterdam/amcat4r) or [Python](https://github.com/ccs-amsterdam/amcat4apiclient) packages to make API calls.

In the default setup, the storage of AmCAT is destroyed when the container is removed.
To set up a folder to permanently store your data in, first create a folder with suitable access rights (the path `~/.elasticsearch/database` is just an example here):[^1]

``` bash
mkdir -p ~/.elasticsearch/database && sudo chown -R 1000:1000 ~/.elasticsearch/database
```

Then uncomment the lines last lines in the elastic7 container in your docker-compose.yml file:

```
    volumes: 
      - ~/.elasticsearch/database:/usr/share/elasticsearch/data  # [local path]:[container path]
```

Build and run the three containers:

``` bash
docker-compose up --pull="missing" -d
# OR
docker-compose up --build -d
```

# Upload to dockerhub (for Contributors)

``` bash
docker image push --all-tags ccsamsterdam/amcat4 && docker image push --all-tags ccsamsterdam/amcat4client
```


[^1]: You can't log in with the password, but need to use middlecat authentication with the web interface.
