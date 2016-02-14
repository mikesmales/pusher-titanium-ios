/**
 * pusher-titanium-ios
 *
 * Created by Mike
 * Copyright (c) 2015 Aplifi. All rights reserved.
 */

#import "UkAplifiPusherIosModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation UkAplifiPusherIosModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"10927b92-80f8-44e8-86a4-396a2c396540";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"uk.aplifi.pusher.ios";
}

#pragma mark Internal
-(id)init {
    
    if (self = [super init]) {

    }
    
    return self;
}

#pragma mark Lifecycle
-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];

	NSLog(@"[INFO] %@ loaded",self);
    
    //[[LoggingHandler sharedLoggingHandler] log:(@"startup")];
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably

	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
	RELEASE_TO_NIL(pusherAdapter);
    
    // release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(id)build:(id)args
{
	return @"build 1.0.0.1";
}

-(void) setup:(id)args
{
    [[LoggingHandler sharedLoggingHandler] log:(@"setup start")];
    
    ENSURE_ARG_COUNT(args, 2);
    NSString *apiKey = [TiUtils stringValue:[args objectAtIndex:0]];
    NSString *authPath = [TiUtils stringValue:[args objectAtIndex:1]];
    
    [[LoggingHandler sharedLoggingHandler] log:(apiKey)];
    [[LoggingHandler sharedLoggingHandler] log:(authPath)];
    
    PusherAdapter *aPusherAdapter = [[PusherAdapter alloc] init];
    [aPusherAdapter setup:apiKey authPath:authPath delegate:self];
    
    pusherAdapter = aPusherAdapter;
}

- (void)connect:(id)args
{
    [[LoggingHandler sharedLoggingHandler] log:(@"connect")];
    
    [pusherAdapter connect];
    
    [[LoggingHandler sharedLoggingHandler] log:(@"connect end")];
}

- (void)disconnect:(id)args
{
    [[LoggingHandler sharedLoggingHandler] log:(@"disconnect")];
    
    [pusherAdapter disconnect];
    
    [[LoggingHandler sharedLoggingHandler] log:(@"disconnect end")];
}

-(id)subscribeChannel:(id)args
{
    
    ENSURE_SINGLE_ARG(args, NSString);
    NSString *channelName = args;
    
    NSString *prefixToRemove = @"private-";
    NSString *channelNameFiltered = [channelName copy];
    if ([channelName hasPrefix:prefixToRemove])
        channelNameFiltered = [channelName substringFromIndex:[prefixToRemove length]];
    
    PTPusherPrivateChannel *channel = [pusherAdapter subscribePrivateChannel:channelNameFiltered];
    
    ChannelAdapter *channelAdapter = [[ChannelAdapter alloc] init];
    [channelAdapter setup:channel];
    
    return channelAdapter;
}

-(void)unsubscribeChannel:(id)args
{
    
    ENSURE_SINGLE_ARG(args, NSString);
    NSString *channelName = args;
    
    [pusherAdapter unsubscribeChannel:channelName];
}

-(void)enableLogging:(id)args
{
    
    BOOL aEnabled = [TiUtils boolValue:[args objectAtIndex: 0]];
    
    [LoggingHandler sharedLoggingHandler].enabled = aEnabled;
}

- (void)handleDisconnectionWithError:(NSError *)error
{
    [[LoggingHandler sharedLoggingHandler] log:(@"handleDisconnectionWithError ")];
    //[[LoggingHandler sharedLoggingHandler] log:[error localizedDescription]];
}

/*
 *  PTPusherDelegate methods
 */

- (BOOL)pusher:(PTPusher *)pusher connectionWillConnect:(PTPusherConnection *)connection
{
    [[LoggingHandler sharedLoggingHandler] log:(@"Pusher client connecting...")];
    return YES;
}

- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection
{
    NSMutableString* logText = [NSMutableString stringWithString: @"Pusher client connected. socketId: "];
    //[logText appendString: connection.socketID];

    [[LoggingHandler sharedLoggingHandler] log:logText];
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error
{
    [[LoggingHandler sharedLoggingHandler] log:(@"PTPusherDelegate failedWithError")];
    
    [self handleDisconnectionWithError:error];
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection didDisconnectWithError:(NSError *)error willAttemptReconnect:(BOOL)willAttemptReconnect
{
    [[LoggingHandler sharedLoggingHandler] log:(@"PTPusherDelegate didDisconnectWithError")];
    
    if (!willAttemptReconnect) {
        [[LoggingHandler sharedLoggingHandler] log:(@"PTPusherDelegate didDisconnectWithError 1")];
        [self handleDisconnectionWithError:error];
        [[LoggingHandler sharedLoggingHandler] log:(@"PTPusherDelegate didDisconnectWithError 2")];
    }
    
    [[LoggingHandler sharedLoggingHandler] log:(@"PTPusherDelegate didDisconnectWithError end")];
}

- (BOOL)pusher:(PTPusher *)pusher connectionWillAutomaticallyReconnect:(PTPusherConnection *)connection afterDelay:(NSTimeInterval)delay
{
    NSMutableString* logText = [NSMutableString stringWithFormat: @"Client automatically reconnecting after %d seconds. SocketId: ", (int)delay];
    
    //[logText appendString: connection.socketID];
    [[LoggingHandler sharedLoggingHandler] log:logText];

    return YES;
}

- (void)pusher:(PTPusher *)pusher didSubscribeToChannel:(PTPusherChannel *)channel
{
    NSMutableString* logText = [NSMutableString stringWithString: @"Subscribed to channel "];
    //[logText appendString: channel.name];
    //[logText appendString: @" socketId: "];
    //[logText appendString: pusher.connection.socketID];
    
    [[LoggingHandler sharedLoggingHandler] log:logText];
}

- (void)pusher:(PTPusher *)pusher didFailToSubscribeToChannel:(PTPusherChannel *)channel withError:(NSError *)error
{
    NSMutableString* logText = [NSMutableString stringWithString: @"Authorization failed for channel "];
    //[logText appendString: channel.name];
    //[logText appendString: @" socketId: "];
    //[logText appendString: pusher.connection.socketID];
    
    [[LoggingHandler sharedLoggingHandler] log:logText];
    [[LoggingHandler sharedLoggingHandler] log:[error localizedDescription]];
}

- (void)pusher:(PTPusher *)pusher didReceiveErrorEvent:(PTPusherErrorEvent *)errorEvent
{
    NSMutableString* logText = [NSMutableString stringWithString: @"Received error event "];
    //[logText appendString: pusher.connection.socketID];
    
    [[LoggingHandler sharedLoggingHandler] log:logText];
    
    NSLog(@"error event %@", errorEvent);
}


- (void)pusher:(PTPusher *)pusher willAuthorizeChannel:(PTPusherChannel *)channel withRequest:(NSMutableURLRequest *)request
{
    NSMutableString* logText = [NSMutableString stringWithString: @"Authorizing channel access..."];
    //[logText appendString: pusher.connection.socketID];
    
    [[LoggingHandler sharedLoggingHandler] log:logText];
    
    NSString *requestBefore = [NSString stringWithFormat:@"Request before: %@", [request allHTTPHeaderFields]];
    [[LoggingHandler sharedLoggingHandler] log:requestBefore];
    
    [request setValue:pusher.connection.socketID forHTTPHeaderField:@"socket_id"];
    [request setValue:channel.name forHTTPHeaderField:@"channel_name"];
    
    NSString *requestAfter = [NSString stringWithFormat:@"Request after: %@", [request allHTTPHeaderFields]];
    [[LoggingHandler sharedLoggingHandler] log:requestAfter];
}


@end
