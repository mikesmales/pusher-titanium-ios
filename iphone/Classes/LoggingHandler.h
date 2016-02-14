//
//  LoggingHandler.h
//  pusher-titanium-ios
//
//  Created by Mike on 14/04/2015.
//
//

#ifndef pusher_titanium_ios_LoggingHandler_h
#define pusher_titanium_ios_LoggingHandler_h


@interface LoggingHandler : NSObject {
}

+ (LoggingHandler *) sharedLoggingHandler;
- (void)log:(NSString *)msg;

@property (getter=isEnabled) BOOL enabled;

@end

#endif
