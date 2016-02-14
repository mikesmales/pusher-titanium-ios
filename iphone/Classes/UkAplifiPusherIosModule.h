/**
 * pusher-titanium-ios
 *
 * Created by Mike
 * Copyright (c) 2015 Aplifi. All rights reserved.
 */

#import "TiModule.h"

#import "PusherAdapter.h"
#import "PTPusherChannel.h"
#import "ChannelAdapter.h"

@interface UkAplifiPusherIosModule : TiModule <PTPusherDelegate>
{
    PusherAdapter *pusherAdapter;
}

-(void)setup:(id)args;
-(void)connect:(id)args;
-(void)disconnect:(id)args;
-(void)enableLogging:(id)args;
-(void)unsubscribeChannel:(id)args;

@end
