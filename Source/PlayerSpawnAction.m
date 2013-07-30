//
//  PlayerSpawnAction.m
//  Flatland
//
//  Created by Josh Bassett on 17/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "NSBundle+InfoDictionaryKeyPath.h"
#import "Player.h"
#import "PlayerSpawnAction.h"

@implementation PlayerSpawnAction

- (void)applyToPlayer:(Player *)player {
  NSNumber *duration = [[NSBundle mainBundle] objectForInfoDictionaryKeyPath:@"Actions.Spawn.Duration"];
  [player spawn:[duration doubleValue]];
}

- (BOOL)validateForPlayer:(Player *)player error:(GameError **)error {
  if (player.isAlive) {
    *error = [[GameError alloc] initWithDomain:GameErrorDomain
                                          code:GameErrorPlayerAlreadySpawned
                                      userInfo:nil];
    return NO;
  }

  if (player.isSpawning) {
    *error = [[GameError alloc] initWithDomain:GameErrorDomain
                                          code:GameErrorPlayerAlreadySpawning
                                      userInfo:nil];
    return NO;
  }

  return [super validateForPlayer:player error:error];
}

@end
