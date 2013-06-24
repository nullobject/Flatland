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
    [self setupWorld];
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
  }

  return self;
}

#pragma mark - ServerDelegate methods

- (NSDictionary *)server:(Server *)server didIdlePlayer:(NSUUID *)uuid {
  [_world idlePlayer:uuid];
  return [_world asJSON];
}

- (NSDictionary *)server:(Server *)server didSpawnPlayer:(NSUUID *)uuid {
  [_world spawnPlayer:uuid];
  return [_world asJSON];
}

- (NSDictionary *)server:(Server *)server didMovePlayer:(NSUUID *)uuid withOptions:(NSDictionary *)options {
  float amount = [(NSNumber *)[options objectForKey:@"amount"] floatValue];
  [_world movePlayer:uuid byAmount:amount];
  return [_world asJSON];
}

- (NSDictionary *)server:(Server *)server didTurnPlayer:(NSUUID *)uuid withOptions:(NSDictionary *)options {
  float amount = [(NSNumber *)[options objectForKey:@"amount"] floatValue];
  [_world turnPlayer:uuid byAmount:amount];
  return [_world asJSON];
}

#pragma mark - Private methods

- (void)setupWorld {
  _world = [WorldScene sceneWithSize:CGSizeMake(1024, 768)];

  // Set the scale mode to scale to fit the window.
  _world.scaleMode = SKSceneScaleModeAspectFit;
}

@end
