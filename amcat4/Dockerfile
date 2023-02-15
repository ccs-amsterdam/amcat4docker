FROM python:3.10.9-alpine3.17

RUN apk add git cargo py3-pip

# install amcat4 (the server)
ENV amcat4_commit ""

WORKDIR /srv/amcat

RUN git clone https://github.com/ccs-amsterdam/amcat4 /srv/amcat
# pin to commit in built
# RUN git checkout ${amcat4_commit}
RUN pip install .
RUN rm -r .git

EXPOSE 5000

CMD ["amcat4", "run"]
