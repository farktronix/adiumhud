//
//  AdiumHUDController.m
//  AdiumHUD
//
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "AdiumHUDController.h"
#import "AdiumHUDPanel.h"
#import <Adium/AIStatus.h>
#import <Adium/AIChat.h>

@implementation AdiumHUDController
- (void) awakeFromNib
{
    [self setHUDSize:kAdiumHUDPanelMinimized];
}

- (id) initWithAdium:(NSObject<AIAdium>*)adium
{
    if ((self = [super init])) {
        _adium = [adium retain];
        
        [[_adium notificationCenter] addObserver:self selector:@selector(chatDidOpen:) name:Chat_DidOpen object:nil];
        [[_adium notificationCenter] addObserver:self selector:@selector(chatWillClose:) name:Chat_WillClose object:nil];
    }
    return self;
}

- (void) dealloc
{
    [_adium release];
    [[_adium notificationCenter] removeObserver:self];
    [super dealloc];
}

- (void) displayStatusText
{
    if ([_statusText isHidden]) {
        NSRect panelFrame = [_hudPanel frame];
        panelFrame.size.height += _statusText.frame.size.height;
        [[_hudPanel animator] setFrame:panelFrame display:YES];
    } else {
        NSRect panelFrame = [_hudPanel frame];
        panelFrame.size.height -= _statusText.frame.size.height;
        [[_hudPanel animator] setFrame:panelFrame display:YES];
    }
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
    
    // resize the window for the detailed status text if necessary
    if (![statusText isEqualToString:@""]) {
        [[_statusText animator] setHidden:YES];
        [_statusText setStringValue:statusText];
        [[_statusText animator] setHidden:NO];
        NSRect panelFrame = [_hudPanel frame];
        panelFrame.size.height += _statusText.frame.size.height;
        [[_hudPanel animator] setFrame:panelFrame display:YES];
    } else {
        if (![_statusText isHidden]) {
            [[_statusText animator] setHidden:YES];
            NSRect panelFrame = [_hudPanel frame];
            panelFrame.size.height -= _statusText.frame.size.height;
            [[_hudPanel animator] setFrame:panelFrame display:YES];
        }
    }
    //[self displayStatusText];
}

- (void) showHUDPanel
{
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

- (void) setHUDSize:(AdiumHUDSize)size
{
    NSRect frame = [_hudPanel frame];
    frame.size.height = size;
    [[_hudPanel animator] setFrame:frame display:YES];
    
    if (size == kAdiumHUDPanelMaximized) {
        [[scrollView_messages animator] setHidden:NO];
        [[controllerView_messages animator] setHidden:NO];
        [[customView_messages animator] setHidden:NO];
        [[messageEntry animator] setHidden:NO];    
    } else {
        [[scrollView_messages animator] setHidden:YES];
        [[controllerView_messages animator] setHidden:YES];
        [[customView_messages animator] setHidden:YES];
        [[messageEntry animator] setHidden:YES];
    }
}

- (void) chatDidOpen:(NSNotification *)notif
{
    [self setHUDSize:kAdiumHUDPanelMaximized];
    
    // fark: this is messy and hacked. i doubt this will work for multiple simultaneous chats, since i've never tested that
    NSSet *allChats = [[_adium chatController] openChats];
    if ( [allChats count] > 0) {
        AIChat *chat = (AIChat *)[[allChats objectEnumerator] nextObject];
        //Create the message view
        messageDisplayController = [[[_adium interfaceController] messageDisplayControllerForChat:chat] retain];
        //Get the messageView from the controller
        controllerView_messages = [[messageDisplayController messageView] retain];
        //scrollView_messages is originally a placeholder; replace it with controllerView_messages
        [controllerView_messages setFrame:[scrollView_messages documentVisibleRect]];
        [[controllerView_messages animator] setAlphaValue:0.85];
        [[customView_messages superview] addSubview:controllerView_messages];
    }
}

- (void) chatWillClose:(NSNotification *)notif
{
    [self setHUDSize:kAdiumHUDPanelMinimized];
    
    [[controllerView_messages animator] removeFromSuperview];
}

@end
