//
//  PlayerAttackAction.m
//  Flatland
//
//  Created by Josh Bassett on 17/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "BulletNode.h"
#import "Player.h"
#import "PlayerAttackAction.h"

@implementation PlayerAttackAction

- (CGFloat)cost {
  return 20;
}

- (void)applyToPlayer:(Player *)player {
  NSAssert(player.isAlive, @"Player has not spawned");
  NSLog(@"Player attacking %@ .", [player.uuid UUIDString]);

  BulletNode *bullet = [[BulletNode alloc] initWithPlayer:player];

  player.state = PlayerStateAttacking;

  [player.playerNode.scene addChild:bullet];
  [super applyToPlayer:player];
}

@end
