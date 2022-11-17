FROM ubuntu:22.04

# install dependencies
RUN apt update && \
    apt upgrade -y && \
    apt install -y \
    git \
    npm \
    nodejs \
    nginx

WORKDIR /srv

# install amcat4client (the web client)
RUN git clone https://github.com/ccs-amsterdam/amcat4client /srv/amcat4client && \
    cd amcat4client && \
    npm install && \
    npx browserslist@latest --update-db && \
    npm run build

COPY amcat.conf /etc/nginx/sites-available/amcat.conf

RUN ln -s /etc/nginx/sites-available/amcat.conf /etc/nginx/sites-enabled/amcat.conf 

# clean up
RUN apt remove -y \
    git \
    npm \
    nodejs && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 5000

CMD ["nginx", "-g", "daemon off;"]
