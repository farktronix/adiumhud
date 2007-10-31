//
//  AdiumHUDController.m
//  AdiumHUD
//
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "AdiumHUDController.h"
#import "AdiumHUDPanel.h"
#import <Adium/AIStatus.h>

@implementation AdiumHUDController
- (void) setStatus:(AIStatus *)status
{
    NSString *statusTypeString = @"";
    NSString *statusText = nil;
    switch ([status statusType]) {
        case AIAvailableStatusType:
            statusTypeString = @"Available";
            statusText = [status statusMessageString];
            break;
        case AIAwayStatusType:
            statusTypeString = @"Away";
            statusText = [status statusMessageString];
            break;
        case AIInvisibleStatusType:
            statusTypeString = @"Invisible";
            break;
        case AIOfflineStatusType:
            statusTypeString = @"Offline";
            break;
    }
    // fark: I have no idea what I'm doing with CoreAnimation. This sort of works, but there's 
    //  got to be a better way to do this.
    [[_statusType animator] setHidden:YES];
    [_statusType setStringValue:statusTypeString];
    [[_statusType animator] setHidden:NO];
    if (statusText == nil) {
        statusText = @"";
    }
    [[_statusText animator] setHidden:YES];
    [_statusText setStringValue:statusText];
    [[_statusText animator] setHidden:NO];
}

- (void) showHUDPanel
{
    [_hudPanel setIsVisible:YES];
}

- (void) hideHUDPanel
{
    [_hudPanel close];
}

- (BOOL) _isVisible
{
    return [_hudPanel isVisible];
}

- (void) toggleHUDPanel
{
    if ([self _isVisible]) {
        [self hideHUDPanel];
    } else {
        [self showHUDPanel];
    }
}

@end
