FROM python:3.10.9-alpine3.17

RUN apk add git cargo

# install amcat4 (the server)
ENV amcat4_commit ""

RUN git clone https://github.com/ccs-amsterdam/amcat4 /srv/amcat
RUN cd /srv/amcat
# pin to commit in built
# RUN git checkout ${amcat4_commit}
RUN pip install .

WORKDIR /srv/amcat

EXPOSE 5000

CMD ["amcat4", "run"]
