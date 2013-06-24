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

- (NSData *)server:(Server *)server didIdlePlayer:(NSUUID *)uuid {
  [_world idlePlayer:uuid];
  return [_world toJSON];
}

- (NSData *)server:(Server *)server didSpawnPlayer:(NSUUID *)uuid {
  [_world spawnPlayer:uuid];
  return [_world toJSON];
}

- (NSData *)server:(Server *)server didMovePlayer:(NSUUID *)uuid withOptions:(NSDictionary *)options {
  float amount = [(NSNumber *)[options objectForKey:@"amount"] floatValue];
  [_world movePlayer:uuid byAmount:amount];
  return [_world toJSON];
}

- (NSData *)server:(Server *)server didTurnPlayer:(NSUUID *)uuid withOptions:(NSDictionary *)options {
  float amount = [(NSNumber *)[options objectForKey:@"amount"] floatValue];
  [_world turnPlayer:uuid byAmount:amount];
  return [_world toJSON];
}

@end
