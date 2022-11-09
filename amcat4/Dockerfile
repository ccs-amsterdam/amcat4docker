FROM ubuntu:22.04

# install dependencies
RUN apt update && \
    apt upgrade -y && \
    apt install -y \
    git \
    python3 \
    python3-pip \
    python3-venv

WORKDIR /srv

# install amcat4 (the server)
ENV amcat4_elastic_host 'elastic7:9200'

RUN git clone https://github.com/ccs-amsterdam/amcat4 /srv/amcat && \
    python3 -m venv amcat/env && \
    cd amcat && \
    env/bin/pip install -e .[dev] && \
    env/bin/python -m amcat4 create-admin --username admin --password admin

EXPOSE 5000

CMD ["/srv/amcat/env/bin/python", "-m", "amcat4", "run"]
# alternative:
# CMD ["/srv/amcat/env/bin/uvicorn", "--proxy-headers", "--forwarded-allow-ips='*'", "--workers=2", "--no-access-log", "--port=5000", "--root-path",  "/api", "amcat4.api:app"]
