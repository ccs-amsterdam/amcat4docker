FROM ubuntu:22.04

# install dependencies
RUN apt update && \
    apt upgrade -y && \
    apt install -y \
    git \
    python3 \
    python3-pip \
    python3-venv

# Add wait-for-it
COPY wait-for-it.sh wait-for-it.sh 
RUN chmod +x wait-for-it.sh

# install amcat4 (the server)
ENV amcat4_elastic_host "elastic7:9200"
ENV amcat4_commit "789eea763881cf81a4ebb5f123df56ac77347846"

RUN git clone https://github.com/ccs-amsterdam/amcat4 /srv/amcat && \
    cd /srv/amcat && \
    # pin to commit in built
    git checkout ${amcat4_commit} && \
    python3 -m venv env && \
    env/bin/pip install -e .[dev]

# make alias to run it as amcat4 instaed of /srv/amcat/env/bin/python -m amcat4
RUN echo '#!/bin/bash\n/srv/amcat/env/bin/python -m amcat4 "$@"' > /usr/bin/amcat4 && \
    chmod +x /usr/bin/amcat4

# clean up
RUN apt remove -y \
    git \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 5000

CMD ["amcat4", "run"]
