//
//  Game.m
//  flatland
//
//  Created by Josh Bassett on 24/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Game.h"
#import "GameError.h"
#import "Player.h"

@implementation Game

- (id)init {
  if (self = [super init]) {
    [self setupServer];
    [self setupWorld];
    [self startTimer];
  }

  return self;
}

- (void)tick {
  [_world tick];

  [_world.players enumerateKeysAndObjectsUsingBlock:^(NSUUID *uuid, Player *player, BOOL *stop) {
    [_server respondToPlayer:uuid withWorld:_world];
  }];
}

#pragma mark - ServerDelegate

- (void)server:(Server *)server didReceiveAction:(PlayerAction *)action forPlayer:(NSUUID *)uuid {
  GameError *error;

  [_world enqueueAction:action forPlayer:uuid error:&error];

  if (error) return [_server respondToPlayer:uuid withError:error];
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
                                 selector:@selector(tick)
                                 userInfo:nil
                                  repeats:YES];
}

@end
