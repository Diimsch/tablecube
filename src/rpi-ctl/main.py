from typing import final
import keybow
import argparse
import asyncio
import time
from gql import gql, Client
from gql.transport.websockets import WebsocketsTransport

keybow.setup(keybow.MINI)

parser = argparse.ArgumentParser(
    description="Restaurant management RPI server")
parser.add_argument('-d', '--destination', help="Backend url", required=True)
parser.add_argument('--jwt', help="JWT for authentication", required=True)
args = vars(parser.parse_args())

# transport = AIOHTTPTransport(url=args['destination'], headers={
#                             'Authorization': 'Bearer %s' % (args["jwt"])})
#client = Client(transport=transport, fetch_schema_from_transport=True)

colorDict = dict([
    ("RED", dict(
        r=255,
        g=0,
        b=0
    )),
    ("GREEN", dict(
        r=0,
        g=255,
        b=0
    )),
])


async def main():
    transport = WebsocketsTransport(url=args["destination"], init_payload={
                                    'Authorization': 'Bearer %s' % (args["jwt"])})
    async with Client(
        transport=transport, fetch_schema_from_transport=True
    ) as session:
        subscription = gql(
            """
            subscription ValidationPrompted($tableId: String!) {
                validationPrompted(tableId: $tableId) {
                    tableId
                    code
                }
            }
            """
        )

        async for result in session.subscribe(subscription, variable_values={
            "tableId": "09ff81b3-b498-43ac-96d9-08ae1800882c"
        }):
            for color in result.code:
                print(color)
                colorData = colorDict.get(color)
                keybow.set_all(colorData.get(
                    "r"), colorData.get("g"), colorData.get("b"))
                await asyncio.sleep(2)
            keybow.clear()
            await asyncio.sleep(3)

'''

colorDict = dict([
    ("RED", dict(
        r=255,
        g=0,
        b=0
    )),
    ("GREEN", dict(
        r=0,
        g=255,
        b=0
    )),
])


@keybow.on()
def handle_input(index, state):
    print("{}: Key {} has been {}".format(
        time.time(),
        index,
        'pressed' if state else 'released'))

    if state:
        colors = colorDict.get(index)
        keybow.set_all(colors.get("r"), colors.get("g"), colors.get("b"))


while True:
    keybow.show()
    time.sleep(1.0 / 60.0)
'''


async def keybow_loop():
    while True:
        keybow.show()
        await asyncio.sleep(1.0 / 60)

loop = asyncio.get_event_loop()
try:
    loop.run_until_complete(main())
    loop.run_until_complete(keybow_loop())
finally:
    loop.close()
