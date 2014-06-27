#Overview
This is a WebSocket, or really, it is an array of WebSockets that acts
as one websocket that provides client side failover and reconnection.
The idea is you use this from single page applications with worldwide
deployment of WebSocket servers to get the best performance and
geographic failover.

You can also use it server to server. We ♥ you.

#Use It
It works like, and has the events of, a WebSocket. One exception, you
connect to an *array* of host names.

A fun way to test this is with our buddy program, which sets up a
totally unreliable websocket that randomly closes on clients to simulate
disconnection:

```
npm install -g the-waffler
waffler 8000 &
waffler 8001 &
```

```
var HuntingWebSocket = require('hunting-websocket');
var socket = new HuntingWebSocket([
  'ws://localhost:8000',
  'ws://localhost:8001']);

socket.onopen = function(evt) {
  //called on the first open, and only once
}

socket.onserver = function(evt) {
  //called any time the socket server has changed, either from a
  //failover or a reconnect
  //evt.server
}

socket.onerror = function(err) {
  //badness detected!
}

socket.onmessage = function(evt) {
  //message in evt.data
}

socket.onclose = function(evt) {
  //by-bye, called on if you really call .close()
}

socket.send('hi');
socket.send('mom');

socket.close()

```

#Browserify!
This package is set up to use with browserify from `npm`, though it is
fundamentally designed to be client side.
