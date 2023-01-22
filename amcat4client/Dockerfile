FROM node:alpine

RUN apk add git

# build amcat4client (the web client)
RUN git clone https://github.com/ccs-amsterdam/amcat4client /srv/amcat4client && \
    chown node:node /srv/amcat4client && \
    cd /srv/amcat4client && \
    sed -i 's/http:\/\/localhost:5000/http:\/\/localhost\/amcat\//g' pages/index.tsx && \
    npm install --production && \
    npx browserslist@latest --update-db

EXPOSE 3000
USER node
WORKDIR /srv/amcat4client

# Run npm start script when container starts
CMD ["npm", "run", "dev"]
