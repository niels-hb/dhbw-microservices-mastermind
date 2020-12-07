FROM node:alpine

# Create work directory
WORKDIR /usr/src/app

# Copy app source to work directory
COPY . /usr/src/app

# Add package deps
RUN apk --no-cache add g++ gcc libgcc libstdc++ linux-headers make python
RUN yarn global add node-gyp

# Install tsc
RUN yarn global add typescript

# Install app dependencies
RUN yarn run presetup

EXPOSE 3000

# Build and run the app
CMD yarn run start:prod
