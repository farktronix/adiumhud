//
//  AdiumHUDPanel.m
//  AdiumHUD
//
//  Created by Jacob Farkas on 10/30/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "AdiumHUDPanel.h"


@implementation AdiumHUDPanel
- (BOOL) canBecomeMainWindow { return YES; }
- (BOOL) setHidesOnDeactivate { return NO; }
- (BOOL) isExcludedFromWindowsMenu { return NO; }

- (void) awakeFromNib
{
    [[NSApplication sharedApplication] addWindowsItem:self
					    title:[self title]
				         filename:NO];
}
@end
