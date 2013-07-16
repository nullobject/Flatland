//
//  PlayerSpawnAction.m
//  Flatland
//
//  Created by Josh Bassett on 17/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Player.h"
#import "PlayerSpawnAction.h"

// Player spawn delay in seconds.
#define kSpawnDelay 3.0

@implementation PlayerSpawnAction

- (void)applyToPlayer:(Player *)player {
  NSAssert(player.isDead, @"Player has already spawned");
  NSLog(@"Spawning player %@ in %f seconds.", [player.uuid UUIDString], kSpawnDelay);
  player.state = PlayerStateSpawning;
  [NSTimer scheduledTimerWithTimeInterval:kSpawnDelay
                                   target:player
                                 selector:@selector(spawn)
                                 userInfo:nil
                                  repeats:NO];
  [super applyToPlayer:player];
}

@end
