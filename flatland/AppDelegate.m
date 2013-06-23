//
//  AppDelegate.m
//  flatland
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "AppDelegate.h"
#import "WorldScene.h"

@implementation AppDelegate {
  WorldScene *_world;
	Server *_server;
}

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  _world = [self world];

  _server = [[Server alloc] init];
  _server.delegate = self;

  NSError *error;
	if (![_server start:&error]) {
		NSLog(@"Error starting HTTP server: %@", error);
	}
}

- (WorldScene *)world {
  WorldScene *world = [WorldScene sceneWithSize:CGSizeMake(1024, 768)];

  // Set the scale mode to scale to fit the window.
  world.scaleMode = SKSceneScaleModeAspectFit;

  [self.skView presentScene:world];

  self.skView.showsFPS       = YES;
  self.skView.showsNodeCount = YES;
  self.skView.showsDrawCount = YES;

  return world;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
  return YES;
}

- (NSData *)server:(Server *)server idlePlayerWithUUID:(NSUUID *)uuid {
  [_world idle:uuid];
  return [_world toJSON];
}

- (NSData *)server:(Server *)server spawnPlayerWithUUID:(NSUUID *)uuid {
  [_world spawn:uuid];
  return [_world toJSON];
}

- (NSData *)server:(Server *)server forwardPlayerWithUUID:(NSUUID *)uuid {
  [_world forward:uuid];
  return [_world toJSON];
}

- (NSData *)server:(Server *)server reversePlayerWithUUID:(NSUUID *)uuid {
  [_world reverse:uuid];
  return [_world toJSON];
}

- (NSData *)server:(Server *)server turnPlayerWithUUID:(NSUUID *)uuid {
  [_world turn:uuid];
  return [_world toJSON];
}

@end
