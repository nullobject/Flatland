//
//  World.m
//  Flatland
//
//  Created by Josh Bassett on 15/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "BulletNode.h"
#import "GameError.h"
#import "NSArray+FP.h"
#import "Player.h"
#import "PlayerAction.h"
#import "World.h"

@interface World ()

@property (nonatomic) WorldNode *worldNode;

@end

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

- (void)tick {
  [_players enumerateKeysAndObjectsUsingBlock:^(NSUUID *uuid, Player *player, BOOL *stop) {
    [player tick];
  }];

  _age += 1;
}

- (BOOL)applyAction:(PlayerAction *)action toPlayer:(NSUUID *)uuid error:(GameError **)error {
  Player *player = [self playerWithUUID:uuid];
  BOOL result = ([action validateForPlayer:player error:error]);

  if (result) {
    [action applyToPlayer:player];
  }

  return result;
}

- (BOOL)enqueueAction:(PlayerAction *)action forPlayer:(NSUUID *)uuid error:(GameError **)error {
  Player *player = [self playerWithUUID:uuid];
  return [player enqueueAction:action error:error];
}


#pragma mark - Callbacks

- (void)playerDidSpawn:(Player *)player {
  NSLog(@"Added player node %@", player.playerNode.name);
  [_worldNode addChild:player.playerNode];
}

- (void)playerDidDie:(Player *)player {
  NSLog(@"Remove player node %@", player.playerNode.name);
  [player.playerNode removeFromParent];
}

- (void)player:(Player *)player didShootBullet:(BulletNode *)bulletNode {
  NSLog(@"Added bullet node %@", bulletNode.name);
  [_worldNode addChild:bulletNode];
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
