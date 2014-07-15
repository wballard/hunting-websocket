Fire up a hunting websocket and see what happens.

    HuntingWebsocket = require('./hunting-websocket.litcoffee')
    socket = new HuntingWebsocket(["ws://localhost:9000", "ws://localhost:9001"])
    ct = 0
    setInterval ->
      socket.send "Hi #{ct++}"
    , 1000
    socket.onmessage = (msg) ->
      console.log msg
