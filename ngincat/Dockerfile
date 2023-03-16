# Base on offical NGINX Alpine image
FROM nginx:alpine

RUN apk add --no-cache certbot certbot-nginx 

# Remove any existing config files
RUN rm /etc/nginx/conf.d/*

# Copy config files
COPY ./amcat.conf /etc/nginx/templates/amcat.conf.template

# entrypoint was changed to not overwrite https configs if present
COPY ./20-envsubst-on-templates.sh /docker-entrypoint.d/20-envsubst-on-templates.sh

# Expose the listening port
EXPOSE 80

# Launch NGINX
CMD ["nginx", "-g", "daemon off;"]
