//
//  ChannelAdapter.h
//  pusher-titanium-ios
//
//  Created by Mike on 14/04/2015.
//
//

#ifndef pusher_titanium_ios_ChannelAdapter_h
#define pusher_titanium_ios_ChannelAdapter_h

#import "TiProxy.h"
#import "TiUtils.h"

#import "PTPusherChannel.h"
#import "PTPusherEvent.h"

#import "LoggingHandler.h"

@interface ChannelAdapter : TiProxy
{
    PTPusherChannel *channel;
    NSMutableDictionary *events;
}

-(void)setup:(PTPusherChannel*) aChannel;
-(void)addEventListener:(id)args;
-(void)sendEvent:(id)args;
-(void)removeEventListener:(id)args;

@end


#endif
