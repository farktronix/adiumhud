//
//  AdiumHUDController.h
//  AdiumHUD
//
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

@class AIStatus;
@class AdiumHUDPanel;

@interface AdiumHUDController : NSObject {
    IBOutlet AdiumHUDPanel *_hudPanel;
    IBOutlet NSTextField *_statusType;
    IBOutlet NSTextField *_statusText;
}
- (void) setStatus:(AIStatus *)status;
- (void) showHUDPanel;
- (void) hideHUDPanel;
- (void) toggleHUDPanel;
@end
