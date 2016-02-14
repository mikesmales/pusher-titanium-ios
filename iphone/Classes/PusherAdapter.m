//
//  PusherAdapter.m
//  pusher-titanium-ios
//
//  Created by Mike on 13/04/2015.
//
//

#import <Foundation/Foundation.h>

#import "PusherAdapter.h"


@implementation PusherAdapter

-(void)setup:(NSString *)apiKey authPath:(NSString *)authPath delegate:(id<PTPusherDelegate>)delegate
{
    [[LoggingHandler sharedLoggingHandler] log:(@"PusherAdapter setup")];
    
    self->pusherClient = [PTPusher pusherWithKey:apiKey delegate:delegate];
    self->pusherClient.authorizationURL = [NSURL URLWithString:authPath];

    //need to retain this.
    [self->pusherClient retain];
    
    [[LoggingHandler sharedLoggingHandler] log:(@"PusherAdapter setup end")];
}

-(void)connect
{
    [[LoggingHandler sharedLoggingHandler] log:(@"connect")];
    [self->pusherClient connect];
    [[LoggingHandler sharedLoggingHandler] log:(@"connect end")];
}

-(void)disconnect
{
    [[LoggingHandler sharedLoggingHandler] log:(@"disconnect")];
    [self->pusherClient disconnect];
    [[LoggingHandler sharedLoggingHandler] log:(@"disconnect end")];
}

-(PTPusherChannel *)subscribeChannel:(NSString *)channelName
{
    [[LoggingHandler sharedLoggingHandler] log:(@"subscribeChannel")];
    PTPusherChannel *channel = [self->pusherClient subscribeToChannelNamed:channelName];
    return channel;
}

-(PTPusherPrivateChannel *)subscribePrivateChannel:(NSString *)channelName
{
    [[LoggingHandler sharedLoggingHandler] log:(@"subscribePrivateChannel")];
    PTPusherPrivateChannel *channel = [self->pusherClient subscribeToPrivateChannelNamed:channelName];
    return channel;
}

-(void)unsubscribeChannel:(NSString *)channelName
{
    [[LoggingHandler sharedLoggingHandler] log:(@"unsubscribeChannel")];
    
    PTPusherChannel *channel = [self->pusherClient channelNamed:channelName];
    
    //returns nil if already unsubscribed from
    if (channel == nil)
    {
        return;
    }
    
    [channel unsubscribe];
}


@end

