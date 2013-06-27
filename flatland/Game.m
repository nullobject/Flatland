//
//  Game.m
//  flatland
//
//  Created by Josh Bassett on 24/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Game.h"

@implementation Game

- (id)init {
  if (self = [super init]) {
    [self setupServer];
    [self setupWorld];
    [self startTimer];
  }

  return self;
}

#pragma mark - ServerDelegate

- (NSObject <Serializable> *)server:(Server *)server didIdlePlayer:(NSUUID *)uuid withOptions:(NSDictionary *)options {
  [_world idlePlayer:uuid];
  return _world;
}

- (NSObject <Serializable> *)server:(Server *)server didSpawnPlayer:(NSUUID *)uuid withOptions:(NSDictionary *)options {
  [_world spawnPlayer:uuid];
  return _world;
}

- (NSObject <Serializable> *)server:(Server *)server didMovePlayer:(NSUUID *)uuid withOptions:(NSDictionary *)options {
  float amount = [(NSNumber *)[options objectForKey:@"amount"] floatValue];
  [_world movePlayer:uuid byAmount:amount];
  return _world;
}

- (NSObject <Serializable> *)server:(Server *)server didTurnPlayer:(NSUUID *)uuid withOptions:(NSDictionary *)options {
  float amount = [(NSNumber *)[options objectForKey:@"amount"] floatValue];
  [_world turnPlayer:uuid byAmount:amount];
  return _world;
}

#pragma mark - Private

- (void)setupServer {
  _server = [[Server alloc] init];
  _server.delegate = self;
}

- (void)setupWorld {
  _world = [WorldScene sceneWithSize:CGSizeMake(1024, 768)];

  // Set the scale mode to scale to fit the window.
  _world.scaleMode = SKSceneScaleModeAspectFit;
}

- (void)startTimer {
  [NSTimer scheduledTimerWithTimeInterval:1
                                   target:self
                                 selector:@selector(update)
                                 userInfo:nil
                                  repeats:YES];
}

// TODO: The update should be split into two phases: gather and settle. During
// the gather phase, the server waits for players to submit their requests.
// During the settle phase the server waits for players' actions to complete,
// before returning a response.
- (void)update {
  [_server update];
}

@end
