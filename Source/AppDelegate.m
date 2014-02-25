//
//  AppDelegate.m
//  Flatland
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "AppDelegate.h"
#import "Game.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  _game = [Game new];

  _skView.showsFPS       = YES;
  _skView.showsNodeCount = YES;
  _skView.showsDrawCount = YES;

  [_skView presentScene:_game.battleScene];

  [_game startServer];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
  return YES;
}

@end
