FROM node:alpine

RUN apk add git

WORKDIR /srv/amcat4client

ARG amcat4_commit=main

# build amcat4client (the web client)
RUN git clone https://github.com/ccs-amsterdam/amcat4client /srv/amcat4client && \
    cd /srv/amcat4client && \
    # pin to commit or branch in built
    git checkout $amcat4client_commit && \
    npm install --production && \
    npx browserslist@latest --update-db

EXPOSE 3000

COPY docker-entrypoint.sh .
ENTRYPOINT ["./docker-entrypoint.sh"]

# Run npm start script when container starts
CMD ["npm", "run", "dev"]
