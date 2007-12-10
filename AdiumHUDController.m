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
#import <Adium/AIChatControllerProtocol.h>

@implementation AdiumHUDController
@synthesize adium = _adium;

- (id) initWithWindowNibName:(NSString *)windowName adium:(NSObject<AIAdium>*)adium
{
    if ((self = [super initWithWindowNibName:windowName])) {
        _adium = [adium retain];
        self.panelSize = kAdiumHUDPanelMinimized;

        [[_adium notificationCenter] addObserver:self selector:@selector(chatDidOpen:) name:Chat_DidOpen object:nil];
        [[_adium notificationCenter] addObserver:self selector:@selector(chatWillClose:) name:Chat_WillClose object:nil];
    }
    return self;
}

- (void) dealloc
{
    [[_adium notificationCenter] removeObserver:self];
    [_adium release];
    [super dealloc];
}

- (void) toggleHUDPanel
{
    if ([[self window] isVisible]) {
        [(AdiumHUDPanel*)[self window] hideHUD];
    } else {
        [(AdiumHUDPanel*)[self window] showHUD];
    }
}

#pragma mark -
#pragma mark Window sizing

- (void) setPanelSize:(AdiumHUDSize)size
{
    _panelSize = size;
    [self resize];
}

- (AdiumHUDSize) panelSize
{
    return _panelSize;
}

- (void) resize
{
    NSRect frame = [[self window] frame];
    frame.size.height = self.panelSize;
    
    if ([_statusText isHidden]) {
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
    
    [[[self window] animator] setFrame:frame display:YES];
}

#pragma mark -
#pragma mark Adium notification handling

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

    [[_statusType animator] setStringValue:statusTypeString];
    [[_statusType animator] setHidden:NO];
    if (statusText == nil) {
        statusText = @"";
    }
    
    // resize the window for the detailed status text if necessary
    if ([statusText isEqualToString:@""]) {
        [[_statusText animator] setHidden:YES];
    } else {
        [[_statusText animator] setStringValue:statusText];
        [[_statusText animator] setHidden:NO];
    }
    
    [self resize];
}

- (void) chatDidOpen:(NSNotification *)notif
{
    self.panelSize = kAdiumHUDPanelMaximized;
    
    AIChat *chat = [[_adium chatController] mostRecentUnviewedChat];
    //Create the message view
    messageDisplayController = [[[_adium interfaceController] messageDisplayControllerForChat:chat] retain];
    //Get the messageView from the controller
    controllerView_messages = [[messageDisplayController messageView] retain];
    //scrollView_messages is originally a placeholder; replace it with controllerView_messages
    [controllerView_messages setFrame:[scrollView_messages documentVisibleRect]];
    [[controllerView_messages animator] setAlphaValue:0.85];
    [[customView_messages superview] addSubview:controllerView_messages];
}

- (void) chatWillClose:(NSNotification *)notif
{
    self.panelSize = kAdiumHUDPanelMinimized;
    
    [[controllerView_messages animator] removeFromSuperview];
}
@end
