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
	Server *_server;
}

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [self setupGame];
  [self setupServer];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
  return YES;
}

#pragma mark - Private methods

- (void)setupGame {
  _game = [[Game alloc] init];

  self.skView.showsFPS       = YES;
  self.skView.showsNodeCount = YES;
  self.skView.showsDrawCount = YES;

  [self.skView presentScene:_game.world];
}

- (void)setupServer {
  _server = [[Server alloc] init];
  _server.delegate = _game;

  NSError *error;
	if (![_server start:&error]) {
		NSLog(@"Error starting HTTP server: %@", error);
	}
}

@end
