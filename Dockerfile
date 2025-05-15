FROM ubuntu:24.04

# Install Node.js and npm
RUN curl -fsSL  https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

# Install elasticdump
RUN npm install elasticdump
