FROM python:3.10.9-alpine3.17

# install dependecies
RUN apk add --update --no-cache --virtual .tmp-build-deps \
    git gcc libc-dev libffi-dev

# install amcat4 (the server)
ENV amcat4_commit ""

WORKDIR /srv/amcat

RUN git clone https://github.com/ccs-amsterdam/amcat4 /srv/amcat && \
    cd /srv/amcat && \
    # pin to commit in built
    git checkout ${amcat4_commit} && \
    pip install . && \
    rm -r .git

EXPOSE 5000

CMD ["amcat4", "run"]
