# set up the network the containers will use to communicate

```bash
docker network create amcat-net
```

# start elasticsearch

```bash
docker run \
    -d \
    --name elastic7 \
    --network amcat-net \
    -e "discovery.type=single-node" \
    -e ES_JAVA_OPTS="-Xms4g" \
    docker.elastic.co/elasticsearch/elasticsearch:7.17.2
```

# build and start the amcat server

```bash
docker build amcat4 \
    --network amcat-net \
    -t ccs-amsterdam/nlpipe:0.0.1
```

```bash
docker run \
    -d \
    --name amcat4 \
    --network amcat-net \
    ccs-amsterdam/amcat4:0.0.1
```

# build and start the amcat client

```bash
docker build amcat4client \
    --network amcat-net \
    -t ccs-amsterdam/amcat4client:0.0.1
```

```bash
docker run \
    -d \
    --name amcat4client \
    --network amcat-net \
    -p 80:5000 \
    ccs-amsterdam/amcat4client:0.0.1
```

# Test

Try to log in at [http://localhost/](http://localhost/) or via the api:

```bash
curl -X POST -F 'username=admin' -F 'password=admin' http://0.0.0.0/api/auth/token
```
