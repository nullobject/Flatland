//
//  AppDelegate.h
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>

#import "Server.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, ServerDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet SKView *skView;

@end
