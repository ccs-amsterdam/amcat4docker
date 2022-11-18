FROM ubuntu:22.04 AS BUILD_IMAGE

# install dependencies
RUN apt update && \
    apt upgrade -y && \
    apt install -y \
    git \
    npm \
    nodejs

# build amcat4client (the web client)
RUN git clone https://github.com/ccs-amsterdam/amcat4client /srv/amcat4client && \
    cd /srv/amcat4client && \
    npm install && \
    npx browserslist@latest --update-db && \
    npm run build

# stage 2 (for smaller image size)
FROM ubuntu:22.04

RUN apt update && \
    apt upgrade -y && \
    apt install -y \
    nginx

# clean up
RUN rm -rf /var/lib/apt/lists/*

# copy client from build image
COPY --from=BUILD_IMAGE /srv/amcat4client/build/ /srv/amcat4client/build/
COPY amcat.conf /etc/nginx/sites-available/amcat.conf

RUN ln -s /etc/nginx/sites-available/amcat.conf /etc/nginx/sites-enabled/amcat.conf 

EXPOSE 5000

CMD ["nginx", "-g", "daemon off;"]
