
# amcat4docker

![flow](amcat-flow-docker.drawio.svg)

To run `Elasticsearch`, `amcat4` and the `amcat4client` from docker, download this repository and build the docker images individually or via `docker-compose`.
For more information, see the [amcat manual](https://amcat-book.netlify.app/).

# Setup

Clone the repository:

``` bash
git clone https://github.com/JBGruber/amcat4docker.git
```

Set up a folder to permanently store your data in (the path `~/.elasticsearch/database` is just an example here):[^1]

``` bash
mkdir -p ~/.elasticsearch/database && sudo chown -R 1000:1000 ~/.elasticsearch/database
```

Build and run the three containers:

``` bash
docker-compose up --build -d
```

# Usage

Before being able to do anything useful through the API, you will need at least one user which can be created with the command below (note, the second `amcat4` is not a typo, but the command, while the first one is the name of the container):

``` bash
docker exec -it amcat4 amcat4 create-admin --username admin --password supergeheim
```

Of course, this new instance is still completely empty, so there is little to see. If you want to add some test data, you can use the create-test-data command, which will upload some State of the Union speeches:

``` bash
docker exec -it amcat4 amcat4 create-test-index
```

After this, you can log into the amcat database using the client at <http://localhost/> or explore the [R](https://github.com/ccs-amsterdam/amcat4r) or [Python](https://github.com/ccs-amsterdam/amcat4apiclient) packages to make API calls.

# For development

Tear down the images and rebuild :bomb::

``` bash
docker stop $(docker ps -f name=amcat -f name=elastic -q) && docker system prune && docker-compose up --build -d
```

[^1]: Comment out the line “volumes:” and the succeeding line to not
    store any data on your host.
