from base64 import decode
from re import M
from typing import final
import keybow
import argparse
import asyncio
import time
from gql import gql, Client
from gql.transport.websockets import WebsocketsTransport
from gql.transport.requests import RequestsHTTPTransport
import jwt

keybow.setup(keybow.MINI)

parser = argparse.ArgumentParser(
    description="Restaurant management RPI server")
parser.add_argument('-d', '--destination', help="Backend url", required=True)
parser.add_argument('--jwt', help="JWT for authentication", required=True)
args = vars(parser.parse_args())


decodedJwt = jwt.decode(args["jwt"], options={
                        "verify_signature": False}, algorithm="HS256")

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
    ("BLUE", dict(
        r=0,
        g=0,
        b=255
    )),
    ("YELLOW", dict(
        r=255,
        g=255,
        b=0
    )),
])

standardColors = [
    dict(
        r=255,
        g=127,
        b=0
    ),
    dict(
        r=127,
        g=0,
        b=255
    ),
    dict(
        r=255,
        g=0,
        b=0
    )
]

indexValues = ['NEEDS_SERVICE', 'PROMPT_CODE', 'DONE']

promptedValidation = False

transport = RequestsHTTPTransport(url='http://%s' % args["destination"], verify=True, retries=3, headers={
    'Authorization': 'Bearer %s' % (args["jwt"])
})

client = Client(transport=transport, fetch_schema_from_transport=True)

changleTableStatusMutation = gql(
    """
mutation ChangeBookingStatus($data: ChangeBookingStatusInput!) {
  changeBookingStatus(data: $data) {
    id
    start
    end
    status
  }
}
"""
)

promptValidationCodeQuery = gql(
    """
query Query($tableId: String!) {
  promptValidation(tableId: $tableId)
}
    """
)


@keybow.on()
def handle_input(index, state):
    global promptedValidation
    if not state:
        if not promptedValidation:
            setBaseColors()
        return

    if promptedValidation:
        return

    task = indexValues[index]
    keybow.set_led(index, 0, 0, 0)
    keybow.show()

    if task == "PROMPT_CODE":
        if promptedValidation == True:
            return
        promptedValidation = True
        result = client.execute(promptValidationCodeQuery, variable_values={
            "tableId": decodedJwt.get("sub"),
        })
        if result.get("promptValidation") == False:
            promptedValidation = False
    else:
        result = client.execute(changleTableStatusMutation, variable_values={
            "data": {
                "tableId": decodedJwt.get("sub"),
                "status": task
            }
        })


def setBaseColors():
    for i, colors in enumerate(standardColors):
        keybow.set_led(i, colors.get("r"), colors.get("g"), colors.get("b"))
    keybow.show()


async def main():
    setBaseColors()
    transport = WebsocketsTransport(url='ws://%s' % args["destination"], init_payload={
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
            "tableId": decodedJwt.get("sub")
        }):

            for color in result['validationPrompted']['code']:
                colorData = colorDict.get(color)
                keybow.set_all(colorData.get(
                    "r"), colorData.get("g"), colorData.get("b"))
                keybow.show()
                await asyncio.sleep(1.5)
                keybow.clear()
                keybow.show()
                await asyncio.sleep(0.7)
            setBaseColors()
            await asyncio.sleep(3)
            global promptedValidation
            promptedValidation = False

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


async def keybow_loop():
    while True:
        keybow.show()
        await asyncio.sleep(1.0 / 60)
'''

loop = asyncio.get_event_loop()
try:
    loop.run_until_complete(main())
    # loop.run_until_complete(keybow_loop())
finally:
    loop.close()
