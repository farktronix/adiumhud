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
- (BOOL) setHidesOnDeactivate { return YES; }
- (BOOL) isExcludedFromWindowsMenu { return NO; }
- (void) awakeFromNib
{
    [[NSApplication sharedApplication] addWindowsItem:self title:[self title] filename:NO];
}
@end
