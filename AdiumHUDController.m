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

    // fark: This animation stuff is a mess. I don't actually know what I'm doing.
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
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.3];
    [_hudPanel setAlphaValue:0.0];
    [_hudPanel setIsVisible:YES];
    [[_hudPanel animator] setAlphaValue:1.0];
    [NSAnimationContext endGrouping];
}

- (void) hideHUDPanel
{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.3];
    [[_hudPanel animator] setAlphaValue:0.0];
    [[_hudPanel animator] close];
    [NSAnimationContext endGrouping];
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
