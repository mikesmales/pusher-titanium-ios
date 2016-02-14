//
//  LoggingHandler.m
//  pusher-titanium-ios
//
//  Created by Mike on 14/04/2015.
//
//

#import <Foundation/Foundation.h>

#import "LoggingHandler.h"

@implementation LoggingHandler

static LoggingHandler *sharedLoggingHandler = nil;

+ (LoggingHandler *)sharedLoggingHandler
{
    //@synchronized(self)
    //{
        if (sharedLoggingHandler == nil)
        {
            sharedLoggingHandler = [[LoggingHandler alloc] init];
            //sharedLoggingHandler.enabled = YES;
        }
        return sharedLoggingHandler;
    //}
}

- (void)log:(NSString *)msg {
    
    if (self.enabled) {
        NSLog(msg);
    }
}

-(void)dealloc
{
    NSLog(@"sharedLoggingHandler dealloc");
    [super dealloc];
}


@end

