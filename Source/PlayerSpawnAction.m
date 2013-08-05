//
//  PlayerSpawnAction.m
//  Flatland
//
//  Created by Josh Bassett on 17/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Player.h"
#import "PlayerSpawnAction.h"

@implementation PlayerSpawnAction

- (NSString *)name {
  return @"spawn";
}

- (void)applyToPlayer:(Player *)player completion:(void (^)(void))block {
  [player spawn:self.duration completion:block];
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

  return YES;
}

@end
