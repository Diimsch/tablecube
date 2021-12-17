# Guide:

### First start:

COPY .env.example to .env

npm install  
npm run codegen  
npm run db:start  
npm run db:init

Run this if you want some basic info in the db:
npm run db:seed

User creds:
user@test.com
user

admin@test.com
admin

### When you are modifying the prisma or graphql schema run:

npm run codegen

### When you want do stuff with hot reloading:

npm run watch
