FROM node:alpine

RUN apk add git

# build nextcat (the web client)
RUN git clone https://github.com/ccs-amsterdam/nextcat /srv/nextcat && \
    cd /srv/nextcat && \
    sed -i 's/http:\/\/localhost:5000/http:\/\/localhost\/amcat\//g' pages/index.tsx && \
    npm install --production && \
    npx browserslist@latest --update-db && \
    npm run build

EXPOSE 3001
USER node
WORKDIR /srv/nextcat

# Run npm start script when container starts
CMD ["npm", "start"]
