//
//  World.m
//  Flatland
//
//  Created by Josh Bassett on 15/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "GameError.h"
#import "NSArray+FP.h"
#import "Player.h"
#import "PlayerAction.h"
#import "World.h"

@implementation World {
  NSMutableDictionary *_players;
}

- (id)init {
  if (self = [super init]) {
    _players = [[NSMutableDictionary alloc] init];
    _worldNode = [[WorldNode alloc] initWithWorld:self];
  }

  return self;
}

- (void)enqueueAction:(PlayerAction *)action forPlayer:(NSUUID *)uuid error:(GameError **)error {
  Player *player = [self playerWithUUID:uuid];
  [player enqueueAction:action error:error];
}

- (void)tick {
  [_players enumerateKeysAndObjectsUsingBlock:^(NSUUID *uuid, Player *player, BOOL *stop) {
    [player tick];
  }];

  _age += 1;
}

- (void)playerDidSpawn:(Player *)player {
  [_worldNode addChild:player.playerNode];
}

- (void)playerDidDie:(Player *)player {
  [player.playerNode removeFromParent];
}

#pragma mark - Serializable

- (NSDictionary *)asJSON {
  NSArray *players = [_players.allValues map:^(Player *player) {
    return [player asJSON];
  }];

  return @{@"age":     [NSNumber numberWithUnsignedInteger:self.age],
           @"players": players};
}

#pragma mark - Private

// Returns the player with the given UUID, if the player doesn't exist then one
// is created.
- (Player *)playerWithUUID:(NSUUID *)uuid {
  Player *player = [_players objectForKey:uuid];

  if (player == nil) {
    player = [[Player alloc] initWithUUID:uuid];
    player.world = self;
    [_players setObject:player forKey:player.uuid];
  }

  return player;
}

@end
