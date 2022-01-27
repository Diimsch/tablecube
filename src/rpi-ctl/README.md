# RPI Table Controller:

## Requirements:

Have Raspberry PI with KEYBOW MINI connected
The RPI Controller can't be used on a normal computer as the raspberry pi dependency cannot be solved without special preinstalled raspberry pi libraries.

## Generate JWT for table:

1. Go to: http://jwtbuilder.jamiekurtz.com/
2. set subject to table id
3. add an additional claim:

- type: type
- value: ROBOT

4. Set Key to: "test"
5. Press created signed JWT and use jwt when initializing table

## Setup:

1. Install pdm for package management (https://pdm.fming.dev/)
2. Run pdm install
3. Run pdm run python3 main.py
4. Pass in all prompted variables
