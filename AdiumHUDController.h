//
//  AdiumHUDController.h
//  AdiumHUD
//
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Adium/Adium.h>

@class AIStatus;
@class AdiumHUDPanel;

typedef enum {
    kAdiumHUDPanelMinimized = 50,
    kAdiumHUDPanelMaximized = 310
} AdiumHUDSize;

@interface AdiumHUDController : NSWindowController {
    NSObject<AIAdium> *_adium;
    
    AdiumHUDSize _panelSize;
    
	NSView								*controllerView_messages;
	IBOutlet	NSScrollView			*scrollView_messages;
	IBOutlet	NSView					*customView_messages;
    
    NSObject<AIMessageDisplayController>    *messageDisplayController;
    
    IBOutlet NSTextField                *messageEntry;
    
    IBOutlet NSTextField *_statusType;
    IBOutlet NSTextField *_statusText;
}
- (id) initWithWindowNibName:(NSString *)windowName adium:(NSObject<AIAdium>*)adium;
- (void) setStatus:(AIStatus *)status;
- (void) toggleHUDPanel;
- (void) resize;

@property (assign) AdiumHUDSize panelSize;
@property (retain) NSObject<AIAdium> *adium;
@end
