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
- (id) initWithAdium:(NSObject<AIAdium>*)adium
{
    if ((self = [super init])) {
        _adium = [adium retain];
    }
    return self;
}

- (void) dealloc
{
    [_adium release];
    [super dealloc];
}

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
    NSSet *allChats = [[_adium chatController] openChats];
    if ( [allChats count] > 0) {
        AIChat *chat = (AIChat *)[[allChats objectEnumerator] nextObject];
        //Create the message view
        messageDisplayController = [[[_adium interfaceController] messageDisplayControllerForChat:chat] retain];
        //Get the messageView from the controller
        controllerView_messages = [[messageDisplayController messageView] retain];
        //scrollView_messages is originally a placeholder; replace it with controllerView_messages
        [controllerView_messages setFrame:[scrollView_messages documentVisibleRect]];
        
        // fark: I believe this is crashing if we bring up the HUD multiple times because the customView is actually the 
        //  controller view
        [[customView_messages superview] replaceSubview:customView_messages with:controllerView_messages];
    }

	//This is what draws our transparent background
	//Technically, it could be set in MessageView.nib, too
	[scrollView_messages setBackgroundColor:[NSColor clearColor]];

    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.3];
    [_hudPanel setAlphaValue:0.0];
    [_hudPanel setIsVisible:YES];
    [_hudPanel becomeMainWindow];
    [_hudPanel makeKeyWindow];
    [[_hudPanel animator] setAlphaValue:1.0];
    [NSAnimationContext endGrouping];
}

- (void) hideHUDPanel
{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.3];
    // TODO: Fade the panel out as it closes
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
