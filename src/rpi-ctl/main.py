#import keybow
import argparse
import time
from gql import gql, Client
from gql.transport.websockets import WebsocketsTransport

# keybow.setup(keybow.MINI)

parser = argparse.ArgumentParser(
    description="Restaurant management RPI server")
parser.add_argument('-d', '--destination', help="Backend url", required=True)
parser.add_argument('--jwt', help="JWT for authentication", required=True)
args = vars(parser.parse_args())

# transport = AIOHTTPTransport(url=args['destination'], headers={
#                             'Authorization': 'Bearer %s' % (args["jwt"])})
#client = Client(transport=transport, fetch_schema_from_transport=True)


async def main():
    transport = WebsocketsTransport(url=args["destination"])
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
        async for result in session.subscribe(subscription):
            print(result)

'''

colorDict = dict([
    (0, dict(
        r=80,
        g=220,
        b=100
    )),
    (1, dict(
        r=205,
        g=92,
        b=92
    )),
    (2, dict(
        r=0,
        g=142,
        b=204
    ))
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
