//
//  AdiumHUDPanel.m
//  AdiumHUD
//
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "AdiumHUDPanel.h"
#import <QuartzCore/CAAnimation.h>

@implementation AdiumHUDPanel
// These overrides are necessary to make the NSPanel show up as the primary window
- (id) initWithContentRect:(NSRect)contentRect styleMask:(unsigned int)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    NSLog(@"AdiumHUDPanel initializing...");
    if (self = [super initWithContentRect: contentRect styleMask:NSNonactivatingPanelMask | NSBorderlessWindowMask | NSClosableWindowMask backing: bufferingType defer:YES]) {
        [self setMovableByWindowBackground:YES];
        [self setBackgroundColor:[NSColor blackColor]];
        [self setOpaque:NO];
        [self setLevel:NSFloatingWindowLevel];
        [self setAlphaValue:0.00];
        
        CAAnimation *anim = [CABasicAnimation animation];
        [anim setDelegate:self];
        [self setAnimations:[NSDictionary dictionaryWithObject:anim forKey:@"alphaValue"]];
    }
    return self;
}

- (void) dealloc
{
    NSLog(@"AdiumHUDPanel going away");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (BOOL) canBecomeKeyWindow { return YES; }
- (BOOL) canBecomeMainWindow { return YES; }
- (BOOL) acceptsFirstResponder { return YES; }
- (BOOL) canBeVisibleOnAllSpaces { return NO; }

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.alphaValue == 0.0) {
        [super orderOut:self];
    }
}

- (void) showHUD
{
    NSLog(@"Showing HUD panel");
    [[self animator] setAlphaValue:0.85];
    [super makeKeyAndOrderFront:self];
}

- (void) hideHUD
{
    NSLog(@"Hiding HUD panel");
    [[self animator] setAlphaValue:0.0];
}
@end
