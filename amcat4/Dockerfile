FROM python:3.11-alpine3.19

# install dependecies
RUN apk add --update --no-cache --virtual .tmp-build-deps \
    git gcc libc-dev libffi-dev libmagic

# install amcat4 (the server)
ENV amcat4_commit ""

WORKDIR /srv/amcat

ARG amcat4_commit=master

RUN git clone https://github.com/ccs-amsterdam/amcat4 /srv/amcat && \
    cd /srv/amcat && \
    # pin to commit or branch in built
    git checkout $amcat4_commit && \
    pip install -e . && \
    rm -r .git

EXPOSE 5000

CMD ["amcat4", "run"]
