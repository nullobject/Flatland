//
//  AppDelegate.m
//  flatland
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "AppDelegate.h"
#import "Game.h"

@implementation AppDelegate {
  Game *_game;
}

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  _game = [[Game alloc] init];

  self.skView.showsFPS       = YES;
  self.skView.showsNodeCount = YES;
  self.skView.showsDrawCount = YES;

  [self.skView presentScene:_game.world];

  NSError *error;
	if (![_game.server start:&error]) {
		NSLog(@"Error starting HTTP server: %@", error);
	}
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
  return YES;
}

@end
