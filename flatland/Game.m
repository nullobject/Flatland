//
//  Game.m
//  flatland
//
//  Created by Josh Bassett on 24/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Action.h"
#import "Game.h"
#import "GameError.h"

@implementation Game {
  NSMutableDictionary *_playerActions;
}

- (id)init {
  if (self = [super init]) {
    _playerActions = [[NSMutableDictionary alloc] init];
    [self setupServer];
    [self setupWorld];
    [self startTimer];
  }

  return self;
}

#pragma mark - ServerDelegate

// TODO: Validate the action before enqueueing it (e.g. player entity has enough energy).
- (void)server:(Server *)server didReceiveAction:(Action *)action forPlayer:(NSUUID *)uuid {
  if (YES) {
    [self enqueueAction:action forPlayer:uuid];
  } else {
    GameError *error = [GameError errorWithDomain:GameErrorDomain code:GameErrorPlayerInsufficientEnergy userInfo:nil];
    [_server respondToPlayer:uuid withError:error];
  }
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

- (void)enqueueAction:(Action *)action forPlayer:(NSUUID *)uuid {
  [_playerActions setObject:action forKey:uuid];
}

// TODO: The update should be split into two phases: gather and settle. During
// the gather phase, the server waits for players to submit their requests.
// During the settle phase the server waits for players' actions to complete,
// before returning a response.
- (void)update {
  [_playerActions enumerateKeysAndObjectsUsingBlock:^(NSUUID *uuid, Action *action, BOOL *stop) {
    [_world runAction:action forPlayer:uuid];
    [_server respondToPlayer:uuid withWorld:_world];
  }];

  [_playerActions removeAllObjects];
}

@end
