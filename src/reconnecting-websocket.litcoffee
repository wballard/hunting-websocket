This has the exact same API as
[WebSocket](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket). So
you get going with:

```
ReconnectingWebSocket = require(reconnecting-websocket)
ws = new ReconnectingWebSocket('ws://...');
```

#Events
##ws
A reference to the contained WebSocket in case you need to poke under the hood.

This may work on the client or the server. Because we love you.

    WebSocket = WebSocket or require('ws')
    background = window.requestAnimationFrame or setTimeout

    class ReconnectingWebSocket
      constructor: (@url) ->
        @couldBeBusted = true
        @forceclose = false
        @readyState = WebSocket.CONNECTING
        @connect()

This is the connection retry system. Keep trying at every opportunity.

        reconnect = =>
          background =>
            if @couldBeBusted and not @forceclose and not @readyState is WebSocket.CONNECTING
              @connect()
            reconnect()
        reconnect()

The all powerful connect function, sets up events and error handling.

      connect: () =>
        @couldBeBusted = false
        @ws = new WebSocket(@url)
        @ws.onopen  = (event) =>
          @readyState = WebSocket.OPEN
          @onopen(event)
        @ws.onclose = (event) =>
          if @forceclose
            @readyState = WebSocket.CLOSED
            @onclose(event)
          else
            @readyState = WebSocket.CONNECTING
            @connect()
        @ws.onmessage = (event) =>
          @onmessage(event)
        @ws.onerror = (event) =>
          @onerror(event)

Sending has an odd uncatchable exception, so use marker flags
to know that we did or did not get past a send.

      send: (data) ->
        @couldBeBusted = true
        @ws.send(data)
        @couldBeBusted = false

      close: ->
        @forceclose = true
        @ws.close()

Empty shims for the event handlers. These are just here for discovery via
the debugger.

      onopen: (event) ->
      onclose: (event) ->
      onmessage: (event) ->
      onerror: (event) ->

Publish this object for browserify.

    module.exports = ReconnectingWebSocket
