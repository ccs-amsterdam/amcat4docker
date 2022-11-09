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

# install amcat4 (the server)
ENV amcat4_elastic_host 'elastic7:9200'
RUN git clone https://github.com/ccs-amsterdam/amcat4client /srv/amcat4client && \
    cd amcat4client && \
    npm install && \
    npm run build

COPY amcat.conf /etc/nginx/sites-available/amcat.conf

RUN ln -s /etc/nginx/sites-available/amcat.conf /etc/nginx/sites-enabled/amcat.conf 

EXPOSE 5000

CMD ["nginx", "-g", "daemon off;"]
