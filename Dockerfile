# Specify the base image and name the build stage as 'build'
FROM node:alpine3.18 AS build

# Build Time Environment Variables
ARG REACT_APP_NODE_ENV
ARG REACT_APP_SERVER_BASE_URL

# Default Values for Environment Variables
ENV REACT_APP_NODE_ENV=$REACT_APP_NODE_ENV
ENV REACT_APP_SERVER_BASE_URL=$REACT_APP_SERVER_BASE_URL

# Building the App
WORKDIR /app
COPY package.json . 
RUN npm install

COPY . . 

RUN npm run build

# Now configure Nginx for serving the build
FROM nginx:1.23-alpine

WORKDIR /usr/share/nginx/html
RUN rm -rf *
COPY --from=build /app/build .

# Expose port 80 to access the app via a web browser
EXPOSE 80

# Run Nginx in the foreground
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
