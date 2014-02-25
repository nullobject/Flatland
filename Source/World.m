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
#import "PlayerNode.h"
#import "PlayerOverlayNode.h"
#import "World.h"

@interface World ()

@property (nonatomic) WorldNode *worldNode;

@end

@implementation World {
  NSMutableDictionary *_players;
}

- (id)init {
  if (self = [super init]) {
    _players = [NSMutableDictionary new];
    _worldNode = [[WorldNode alloc] initWithWorld:self];
  }

  return self;
}

- (BOOL)enqueueAction:(PlayerAction *)action forPlayer:(NSUUID *)uuid completion:(void (^)(void))block error:(GameError **)error {
  Player *player = [self playerWithUUID:uuid];
  return [player applyAction:action completion:block error:error];
}

- (void)tick {
  [_players enumerateKeysAndObjectsUsingBlock:^(NSUUID *uuid, Player *player, BOOL *stop) {
    [player tick];
  }];

  _age += 1;
}

#pragma mark - Callbacks

- (void)playerDidSpawn:(Player *)player {
  [_worldNode addChild:player.playerNode];
  [_worldNode addChild:player.playerOverlayNode];
  NSLog(@"Added player node %@", player.playerNode.name);
}

- (void)playerDidDie:(Player *)player {
  [player.playerOverlayNode removeFromParent];
  [player.playerNode removeFromParent];
  NSLog(@"Removed player node %@", player.playerNode.name);
}

- (void)player:(Player *)player didShootBullet:(BulletNode *)bulletNode {
  [_worldNode addChild:bulletNode];
  NSLog(@"Added bullet node %@", bulletNode.name);
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
