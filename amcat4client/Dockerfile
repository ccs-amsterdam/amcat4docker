FROM node:alpine

RUN apk add git

WORKDIR /srv/amcat4client

# build amcat4client (the web client)
RUN git clone https://github.com/ccs-amsterdam/amcat4client /srv/amcat4client && \
    cd /srv/amcat4client && \
    npm install --production && \
    npx browserslist@latest --update-db

EXPOSE 3000

COPY docker-entrypoint.sh .
ENTRYPOINT ["./docker-entrypoint.sh"]

# Run npm start script when container starts
CMD ["npm", "run", "dev"]