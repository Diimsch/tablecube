##Backend
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


##Frontend

### Requirements
    - nodeJS
    - flutter

### Getting Started

1. RUN flutter pub get
2. RUN flutter run

If flutter detects multiple devices on your system, you have to decide where you want to open the application.
Every action in code will be hotfixed while saving when you use VSC Debugger an on console with press on 'R'.

### Build

Build Android:
    - flutter build apk
Build Web:
    - flutter build web
Build IOS (only on MAC):
    - flutter build ios

### Configuration
Edit backend endpoint in /src/frontend/api.dart.


## RPI Table Controller:

### Requirements:

Have Raspberry PI with KEYBOW MINI connected
The RPI Controller can't be used on a normal computer as the raspberry pi dependency cannot be solved without special preinstalled raspberry pi libraries.

### Setup:

1. Install pdm for package management (https://pdm.fming.dev/)
2. Run pdm install
3. Run pdm run python3 main.py
4. Pass in all prompted variables