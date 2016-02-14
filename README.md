#Pusher Titanium iOS module

Pusher client library for Titanium **iOS** 

##Module Overview

Here is the module in a nutshell.

``` javascript
var pusher = require('uk.aplifi.pusher.ios’);
pusher.setup(key, authUrl);
pusher.connect();

var channel = pusher.subscribeChannel('channelName');

channel.addEventListener('channelEvent', function(event) {
	//Received event
	Ti.API.debug(JSON.stringify(event));
	//Event data
	Ti.API.debug(JSON.stringify(event.data));
});

pusher.disconnect();
```

More information in reference format can be found below.

##Configuration

The standard constructor take an application key which you can get from the app's API Access section in the Pusher dashboard at https://app.pusher.com.

You need to provide an authorization endpoint for using [private](https://pusher.com/docs/client_api_guide/client_private_channels) or [presence](https://pusher.com/docs/client_api_guide/client_presence_channels) channels. 

``` javascript
var pusher = require('uk.aplifi.pusher.android');
pusher.setup(key, authUrl);
```

##Connecting

In order to send and receive messages you need to connect to Pusher. 

``` javascript
pusher.connect();
```


##Disconnecting

``` javascript
pusher.disconnect();
```

##Subscribing to Channels

Connect to a Channel, then specify an event listener to subscribe to as follows. 

``` javascript
var channel = pusher.subscribeChannel('channelName');

channel.addEventListener('channelEvent', function(event) {
	//Received event
	Ti.API.debug(JSON.stringify(event));
	//Event data
	Ti.API.debug(JSON.stringify(event.data));
});

```

##Publishing Channel events

Once you are subscribed to a Channel, you can publish events as follows.
``` javascript
channel.sendEvent('channelEvent', '{"myName": "Bob"}');
```

##Debug logging

Logging is there for debug purposes. It is automatically disabled for security reasons. 

``` javascript
pusher.enableLogging(true);
```