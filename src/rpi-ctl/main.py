import keybow
import time

keybow.setup(keybow.MINI)

colorDict = dict([
    (0, dict(
        r = 80,
        g = 220,
        b = 100
    )),
    (1, dict(
        r = 205,
        g = 92,
        b = 92
    )),
    (2, dict(
        r = 0,
        g = 142,
        b = 204
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