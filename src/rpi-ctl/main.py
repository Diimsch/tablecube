import argparse
import asyncio
import os
import jwt
import keybow
from aiostream import stream
from dotenv import load_dotenv
from gql import Client, gql
from gql.transport.exceptions import TransportQueryError
from gql.transport.requests import RequestsHTTPTransport
from gql.transport.websockets import WebsocketsTransport

load_dotenv()
keybow.setup(keybow.MINI)

parser = argparse.ArgumentParser(
    description="Restaurant management RPI server")
parser.add_argument('-d', '--destination', help="Backend url",
                    default=os.environ.get("DESTINATION"))
parser.add_argument('--jwt', help="JWT for authentication",
                    default=os.environ.get("JWT"))
args = vars(parser.parse_args())
if not "jwt" in args or not "destination" in args:
    exit(parser.print_usage())


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
status = 'DONE'

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

promptValidationCodeMutation = gql(
    """
mutation Mutation($tableId: String!) {
  promptValidation(tableId: $tableId)
}
    """
)

tableQuery = gql(
    """
query Table($tableId: ID!) {
  table(tableId: $tableId) {
    occupyingBooking {
      status
    }
  }
}
    """
)

blink_task: asyncio.Task = None


blink_event = asyncio.Event()
blink_index = -1
blink_r = 0
blink_g = 0
blink_b = 0


def blink(index, r, g, b):
    global blink_r, blink_g, blink_b, blink_index, blink_event
    blink_index = index
    blink_r = r
    blink_g = g
    blink_b = b
    if blink_index >= 0:
        blink_event.set()


def cancel_blink():
    blink_event.clear()


async def blink_loop():
    while True:
        await blink_event.wait()
        if not promptedValidation:
            keybow.set_led(blink_index, 0, 0, 0)
            keybow.show()
        await asyncio.sleep(0.5)
        if not promptedValidation:
            keybow.set_led(blink_index, blink_r, blink_g, blink_b)
            print("blinking: %d %d %d %d" %
                  (blink_index, blink_r, blink_g, blink_b))
            keybow.show()
        await asyncio.sleep(0.5)


@keybow.on()
def handle_input(index, state):
    global promptedValidation
    if status == "DONE":
        return

    if not state:
        if not promptedValidation:
            setBaseColors(status)
        return

    if promptedValidation:
        return

    task = indexValues[index]
    keybow.set_led(index, 0, 0, 0)
    keybow.show()

    try:
        if task == "PROMPT_CODE":
            if promptedValidation == True:
                return
            promptedValidation = True
            result = client.execute(promptValidationCodeMutation, variable_values={
                "tableId": decodedJwt.get("sub"),
            })
            if result.get("promptValidation") == False:
                promptedValidation = False
        else:
            if status == "RESERVED":
                return
            if status == task:
                task = "CHECKED_IN"
            result = client.execute(changleTableStatusMutation, variable_values={
                "data": {
                    "tableId": decodedJwt.get("sub"),
                    "status": task
                }
            })
    except TransportQueryError as err:
        print(err.errors)


def setBaseColors(status):
    cancel_blink()
    if status == "DONE":
        keybow.set_all(0, 255, 0)
    elif status == "RESERVED":
        keybow.set_led(0, 255, 127, 0)
        keybow.set_led(1, 127, 0, 255)
        keybow.set_led(2, 255, 127, 0)
    else:
        for i, colors in enumerate(standardColors):
            if i == 0 and status == "NEEDS_SERVICE":
                blink(i, colors.get(
                    "r"), colors.get("g"), colors.get("b"))
            keybow.set_led(i, colors.get(
                "r"), colors.get("g"), colors.get("b"))
    keybow.show()


async def main():
    asyncio.create_task(blink_loop())

    transport = WebsocketsTransport(url='ws://%s' % args["destination"], init_payload={
                                    'Authorization': 'Bearer %s' % (args["jwt"])})
    async with Client(
        transport=transport, fetch_schema_from_transport=True
    ) as session:
        subscription = gql(
            """
            subscription ValidationPrompted($tableId: ID!) {
                validationPrompted(tableId: $tableId) {
                    tableId
                    code
                }
            }
            """
        )

        tableStatus = gql(
            """
subscription TableUpdated($tableId: ID!) {
  tableUpdated(tableId: $tableId) {
    tableId
    status
  }
}
            """
        )

        global promptedValidation
        global status

        tableStatusEvents = session.subscribe(tableStatus, variable_values={
            "tableId": decodedJwt.get("sub")
        })

        colorPromptEvents = session.subscribe(subscription, variable_values={
            "tableId": decodedJwt.get("sub")
        })

        combinedEvents = stream.merge(tableStatusEvents, colorPromptEvents)

        tableRes = await session.execute(tableQuery, variable_values={
            "tableId": decodedJwt.get("sub")
        })

        occupyingBooking = tableRes["table"]["occupyingBooking"]
        if occupyingBooking is not None:
            status = occupyingBooking["status"]
        setBaseColors(status)

        async with combinedEvents.stream() as streamer:
            async for result in streamer:
                if "tableUpdated" in result:
                    if result["tableUpdated"]["tableId"] != decodedJwt.get("sub"):
                        continue
                    status = result["tableUpdated"]["status"]
                    if not promptedValidation:
                        setBaseColors(status)
                else:
                    if result["validationPrompted"]["tableId"] != decodedJwt.get("sub"):
                        continue
                    for color in result['validationPrompted']['code']:
                        colorData = colorDict.get(color)
                        keybow.set_all(colorData.get(
                            "r"), colorData.get("g"), colorData.get("b"))
                        keybow.show()
                        await asyncio.sleep(1.5)
                        keybow.clear()
                        keybow.show()
                        await asyncio.sleep(0.7)
                    setBaseColors(status)
                    promptedValidation = False

loop = asyncio.get_event_loop()
try:
    loop.run_until_complete(main())
finally:
    loop.close()
