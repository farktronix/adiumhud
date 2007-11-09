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
    [self resize];
}

- (id) initWithAdium:(NSObject<AIAdium>*)adium
{
    if ((self = [super init])) {
        _adium = [adium retain];
        self.panelSize = kAdiumHUDPanelMinimized;
        
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
    if ([statusText isEqualToString:@""]) {
        [[_statusText animator] setHidden:YES];
    } else {
        [[_statusText animator] setHidden:YES];
        [_statusText setStringValue:statusText];
        [[_statusText animator] setHidden:NO];
    }
    
    [self resize];
}

- (void) showHUDPanel
{
    [_hudPanel setAlphaValue:0.0];
    [_hudPanel setIsVisible:YES];
    [[_hudPanel animator] setAlphaValue:1.0];
}

- (void) hideHUDPanel
{
    // TODO: Fade the panel out as it closes
    [[_hudPanel animator] setAlphaValue:0.0];
    [[_hudPanel animator] setIsVisible:NO];
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

- (void) resize
{
    NSRect frame = [_hudPanel frame];
    frame.size.height = self.panelSize;
    
    if (![_statusText isHidden]) {
        frame.size.height += _statusText.frame.size.height;
    }
    
    if (self.panelSize == kAdiumHUDPanelMaximized) {
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
    
    [[_hudPanel animator] setFrame:frame display:YES];
}

- (void) chatDidOpen:(NSNotification *)notif
{
    self.panelSize = kAdiumHUDPanelMaximized;
    
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
    self.panelSize = kAdiumHUDPanelMinimized;
    
    [[controllerView_messages animator] removeFromSuperview];
}

- (void) setPanelSize:(AdiumHUDSize)size
{
    _panelSize = size;
    [self resize];
}

- (AdiumHUDSize) panelSize
{
    return _panelSize;
}
@end
