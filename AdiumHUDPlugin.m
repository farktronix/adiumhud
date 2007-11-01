//
//  AdiumHUDPlugin.m
//  AdiumHUD
//
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "AdiumHUDPlugin.h"
#import <Adium/AIStatusItem.h>
#import <Adium/AIStatus.h>
#import <Adium/AIStatusControllerProtocol.h>

static NSString *pluginVersion = @"0.1";

static OSStatus hotKeyEventHandler(EventHandlerCallRef inHandlerRef, EventRef inEvent, void* refCon )
{
	return [[AdiumHUDPlugin sharedHUDPlugin] sendCarbonEvent:inEvent];
}

AdiumHUDPlugin *_sAdiumHUDPlugin = nil;
@implementation AdiumHUDPlugin

- (id) init
{
    if (self = [super init]) {
        _eventHandlerInstalled = NO;
    }
    return self;
}

#pragma mark -
#pragma  mark HotKey handling

+ (AdiumHUDPlugin *)sharedHUDPlugin
{
    return _sAdiumHUDPlugin;
}

- (OSStatus)sendCarbonEvent: (EventRef)event
{
	OSStatus err;
	EventHotKeyID hotKeyID;

	NSAssert( GetEventClass( event ) == kEventClassKeyboard, @"Unknown event class" );

	err = GetEventParameter(	event,
								kEventParamDirectObject, 
								typeEventHotKeyID,
								nil,
								sizeof(EventHotKeyID),
								nil,
								&hotKeyID );
	if( err )
		return err;
	

	NSAssert( hotKeyID.signature == 'ahud', @"Invalid hot key id" );
//	NSAssert( hotKeyID.id != nil, @"Invalid hot key id" );

	switch( GetEventKind( event ) )
	{
		case kEventHotKeyPressed:
            [_hudController toggleHUDPanel];
		break;

//		case kEventHotKeyReleased:
//            NSLog(@"Hiding HUD panel");
//            [_hudController hideHUDPanel];
//		break;

		default:
			NSAssert( 0, @"Unknown event kind" );
		break;
	}
	
	return noErr;
}


- (void)_updateEventHandler
{
	if( _eventHandlerInstalled == NO )
	{
		EventTypeSpec eventSpec[1] = {
			{ kEventClassKeyboard, kEventHotKeyPressed },
//			{ kEventClassKeyboard, kEventHotKeyReleased }
		};    

		InstallApplicationEventHandler(hotKeyEventHandler, 1, eventSpec, NULL, NULL);
	
		_eventHandlerInstalled = YES;
	}
}

- (void) registerHotKey
{
	OSStatus err;
	EventHotKeyID hotKeyID;
    	
	hotKeyID.signature = 'ahud';
	hotKeyID.id = (long)self;
    
	[self _updateEventHandler]; 
	
	err = RegisterEventHotKey(  kVK_Space,
								optionKey,
								hotKeyID,
								GetApplicationEventTarget(),
								0,
								&_carbonHotKey );

	if( err )
		NSLog(@"could not register hot key: %d", err);

}

- (void) _stateChanged:(NSNotification *)notif
{
    [_hudController setStatus:[[adium statusController] activeStatusState]];
}

#pragma mark -
#pragma mark AIPlugin Support

- (void)installPlugin
{
    NSLog(@"AdiumHUD plugin starting up");
    _sAdiumHUDPlugin = [self retain];
    [self registerHotKey];
    
    _hudController = [[AdiumHUDController alloc] init];
    if (![NSBundle loadNibNamed:@"AdiumHUD" owner:_hudController]) {
        NSLog(@"Could not bundle load AdiumHUD UI");
        return;
    }
    
    [[adium notificationCenter] addObserver:self selector:@selector(_stateChanged:) name:AIStatusActiveStateChangedNotification object:nil];
}

- (void)uninstallPlugin
{
    [_hudController release];
    [_sAdiumHUDPlugin release];
    _sAdiumHUDPlugin = nil;
}

- (NSString *)pluginAuthor
{
    return @"Jacob Farkas and Ryan Joseph";
}

- (NSString *)pluginVersion
{
    return pluginVersion;
}

- (NSString *)pluginDescription
{
    return @"Creates a Heads Up Display for managing Adium conversations";
}

- (NSString *)pluginURL
{
    return @"http://farktronix.com/AdiumHUD/";
}
@end
