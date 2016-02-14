//
//  PusherAdapter.h
//  pusher-titanium-ios
//
//  Created by Mike on 13/04/2015.
//
//

#ifndef pusher_titanium_ios_PusherAdapter_h
#define pusher_titanium_ios_PusherAdapter_h

#import "PTPusher.h"
#import "PTPusherDelegate.h"
#import "LoggingHandler.h"
#import "PTPusherChannel.h"

#import "LoggingHandler.h"

@interface PusherAdapter : NSObject
{
    PTPusher *pusherClient;
}

- (void) setup:(NSString *)apiKey authPath:(NSString *)authPath delegate:(id<PTPusherDelegate>)delegate;
- (void) connect;
- (void) disconnect;

- (PTPusherChannel *)subscribeChannel:(NSString *)channelName;
- (PTPusherPrivateChannel *)subscribePrivateChannel:(NSString *)channelName;
- (void)unsubscribeChannel:(NSString *)channelName;

@end

#endif
