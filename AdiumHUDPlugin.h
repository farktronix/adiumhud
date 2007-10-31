//
//  AdiumHUDPlugin.h
//  AdiumHUD
//
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Adium/AIPlugin.h>
#import <Carbon/Carbon.h>
#import "AdiumHUDController.h"

@interface AdiumHUDPlugin : AIPlugin {
	EventHotKeyRef _carbonHotKey;
    BOOL _eventHandlerInstalled;
    
    AdiumHUDController *_hudController;
}
+ (AdiumHUDPlugin *)sharedHUDPlugin;
- (OSStatus)sendCarbonEvent: (EventRef)event;
@end
