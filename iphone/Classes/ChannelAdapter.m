//
//  ChannelAdapter.m
//  pusher-titanium-ios
//
//  Created by Mike on 14/04/2015.
//
//

#import <Foundation/Foundation.h>

#import "ChannelAdapter.h"


@implementation ChannelAdapter


- (void) setup:(PTPusherChannel *)aChannel
{
    [[LoggingHandler sharedLoggingHandler] log:(@"ChannelAdapter setup")];
    
    self->channel = aChannel;
    [channel retain];
    
    self->events = [[NSMutableDictionary alloc] init];
    [events retain];
    
    [[LoggingHandler sharedLoggingHandler] log:(@"ChannelAdapter end")];
}

-(void)addEventListener:(id)args
{
    [[LoggingHandler sharedLoggingHandler] log:(@"ChannelAdapter listenToEvent")];
    
    ENSURE_ARG_COUNT(args, 2);
    NSString *aEventName = [TiUtils stringValue:[args objectAtIndex:0]];
    KrollCallback* callback = [args objectAtIndex:1];
    
    [callback retain];
    
    [[LoggingHandler sharedLoggingHandler] log:(aEventName)];
    
    
    PTPusherEventBinding *binding =[channel bindToEventNamed:aEventName handleWithBlock:^(PTPusherEvent *channelEvent) {
        
        [[LoggingHandler sharedLoggingHandler] log:(@"ChannelAdapter bindToEventNamed start")];

        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setObject:channelEvent.data forKey:@"data"];
        
        [callback call:[NSArray arrayWithObject:data] thisObject:nil];
        //[self _fireEventToListener:channelEvent.name withObject:channelEvent.data listener:callback thisObject:nil];
        
        [[LoggingHandler sharedLoggingHandler] log:(@"ChannelAdapter bindToEventNamed end")];
    }];
    
    //if binding is not null
    //add to events dict
    if (binding != nil)
    {
        [self->events setObject:binding forKey:aEventName];
    }
    
    [[LoggingHandler sharedLoggingHandler] log:(@"ChannelAdapter listenToEvent end")];
}

-(void)sendEvent:(id)args
{
    ENSURE_ARG_COUNT(args, 2);
    NSString *aEventName = [TiUtils stringValue:[args objectAtIndex:0]];
    NSDictionary *aEventData = [args objectAtIndex:1];
    
    [[LoggingHandler sharedLoggingHandler] log:(@"ChannelAdapter sendEvent")];
    
    [self->channel triggerEventNamed:aEventName data:aEventData];
    
    //(void)triggerEventNamed:(NSString *)eventName data:(id)eventData;
    
    
    [[LoggingHandler sharedLoggingHandler] log:(@"ChannelAdapter sendEvent end")];
}

-(void)removeEventListener:(id)args
{
    [[LoggingHandler sharedLoggingHandler] log:(@"ChannelAdapter removeEventListener")];
    
    ENSURE_ARG_COUNT(args, 1);
    NSString *aEventName = [TiUtils stringValue:[args objectAtIndex:0]];
    
    PTPusherEventBinding *binding = [self->events objectForKey:aEventName];
    
    if (binding) {
        [self->channel removeBinding:binding];
    }
}


@end
