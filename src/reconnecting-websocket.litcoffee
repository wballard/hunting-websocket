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

    WebSocket = window.WebSocket
    background = window.requestAnimationFrame or setTimeout

    class ReconnectingWebSocket
      constructor: (@url) ->
        console.log "Hello #{@url}"
        @couldBeBusted = true
        @forceclose = false
        @allowReconnect = false
        @connect()
        @reconnect()

This is the connection retry system. Keep trying at every opportunity.

      reconnect: () ->
        background =>
          @reconnect()
          if not @forceclose
            if @readyState isnt WebSocket.OPEN
              if Date.now() > @reconnectAfter
                @connect()

The all powerful connect function, sets up events and error handling.

      connect: () ->
        @reconnectAfter = Date.now() + 200
        @readyState = WebSocket.CONNECTING
        @ws = new WebSocket(@url)
        @ws.onopen  = (event) =>
          @readyState = WebSocket.OPEN
          @reconnectAfter = Date.now() * 2
          @onopen(event)
        @ws.onclose = (event) =>
          @reconnectAfter = 0
          if @forceclose
            @readyState = WebSocket.CLOSED
            @onclose(event)
          else
            @readyState = WebSocket.CONNECTING
        @ws.onmessage = (event) =>
          @onmessage(event)
        @ws.onerror = (event) =>
          @reconnectAfter = 0
          @onerror(event)

Sending has an odd uncatchable exception, so use marker flags
to know that we did or did not get past a send.

      send: (data) ->
        state = @readyState
        @readyState = WebSocket.CLOSING
        @ws.send(data)
        @readyState = state

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
