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

@interface AdiumHUDController : NSObject {
    NSObject<AIAdium> *_adium;
    
    AdiumHUDSize _panelSize;

    IBOutlet AdiumHUDPanel *_hudPanel;
    
	NSView								*controllerView_messages;
	IBOutlet	NSScrollView			*scrollView_messages;
	IBOutlet	NSView					*customView_messages;
    
    NSObject<AIMessageDisplayController>	*messageDisplayController;
    
    IBOutlet NSTextField                *messageEntry;
    
    IBOutlet NSTextField *_statusType;
    IBOutlet NSTextField *_statusText;
}
- (id) initWithAdium:(NSObject<AIAdium>*)adium;
- (void) setStatus:(AIStatus *)status;
- (void) showHUDPanel;
- (void) hideHUDPanel;
- (void) toggleHUDPanel;
- (void) resize;

@property (assign) AdiumHUDSize panelSize;
@end
