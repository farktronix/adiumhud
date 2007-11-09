//
//  AdiumHUDPanel.m
//  AdiumHUD
//
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "AdiumHUDPanel.h"

@implementation AdiumHUDPanel
// These overrides are necessary to make the NSPanel show up as the primary window
- (BOOL) canBecomeMainWindow { return YES; }
- (BOOL) canBecomeKeyWindow { return YES; }
- (BOOL) setHidesOnDeactivate { return YES; }
- (BOOL) isExcludedFromWindowsMenu { return NO; }
- (BOOL) canBeVisibleOnAllSpaces { return NO; }
- (void) awakeFromNib
{
    [[NSApplication sharedApplication] addWindowsItem:self title:[self title] filename:NO];
}

- (void)becomeKeyWindow { NSLog(@"%s", __PRETTY_FUNCTION__); }
- (void)resignKeyWindow { NSLog(@"%s", __PRETTY_FUNCTION__); }
- (void)becomeMainWindow { NSLog(@"%s", __PRETTY_FUNCTION__); }
- (void)resignMainWindow { NSLog(@"%s", __PRETTY_FUNCTION__); }
- (void)windowDidResize:(NSNotification *)notification { NSLog(@"%s", __PRETTY_FUNCTION__); }
- (void)windowDidExpose:(NSNotification *)notification { NSLog(@"%s", __PRETTY_FUNCTION__); }
- (void)windowWillMove:(NSNotification *)notification { NSLog(@"%s", __PRETTY_FUNCTION__); }
- (void)windowDidMove:(NSNotification *)notification { NSLog(@"%s", __PRETTY_FUNCTION__); }
- (void)windowDidBecomeKey:(NSNotification *)notification { NSLog(@"%s", __PRETTY_FUNCTION__); }
- (void)windowDidResignKey:(NSNotification *)notification { NSLog(@"%s", __PRETTY_FUNCTION__); }
- (void)windowDidBecomeMain:(NSNotification *)notification { NSLog(@"%s", __PRETTY_FUNCTION__); }
- (void)windowDidResignMain:(NSNotification *)notification { NSLog(@"%s", __PRETTY_FUNCTION__); }
- (void)windowWillClose:(NSNotification *)notification { NSLog(@"%s", __PRETTY_FUNCTION__); }
- (void)windowWillMiniaturize:(NSNotification *)notification { NSLog(@"%s", __PRETTY_FUNCTION__); }
- (void)windowDidMiniaturize:(NSNotification *)notification { NSLog(@"%s", __PRETTY_FUNCTION__); }
- (void)windowDidDeminiaturize:(NSNotification *)notification { NSLog(@"%s", __PRETTY_FUNCTION__); }
- (void)windowDidUpdate:(NSNotification *)notification { NSLog(@"%s", __PRETTY_FUNCTION__); }
- (void)windowDidChangeScreen:(NSNotification *)notification { NSLog(@"%s", __PRETTY_FUNCTION__); }

@end
