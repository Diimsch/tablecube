FROM node:lts-alpine

RUN apk update
RUN apk add openssl

# Create app directory
WORKDIR /app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm ci

# Bundle app source
COPY . .

RUN npm run codegen
RUN npm run build

COPY ./src/schema.graphql ./dist

EXPOSE 4000
CMD [ "node", "dist/index.js" ]