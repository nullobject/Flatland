//
//  PlayerAction.m
//  Flatland
//
//  Created by Josh Bassett on 2/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Player.h"
#import "PlayerAction.h"
#import "PlayerSpawnAction.h"

@implementation PlayerAction

- (CGFloat)cost {
  return 0;
}

- (id)initWithOptions:(NSDictionary *)options {
  if (self = [super init]) {
    _options = options;
  }

  return self;
}

- (void)applyToPlayer:(Player *)player {
}

- (BOOL)validateForPlayer:(Player *)player error:(GameError **)error {
  // Ensure the player is alive.
  if (!player.isAlive) {
    *error = [[GameError alloc] initWithDomain:GameErrorDomain
                                          code:GameErrorPlayerNotSpawned
                                      userInfo:nil];
    return NO;
  }

  // Ensure the player has enough energy to perform the action.
  if (player.energy < self.cost) {
    *error = [[GameError alloc] initWithDomain:GameErrorDomain
                                          code:GameErrorPlayerInsufficientEnergy
                                      userInfo:nil];
    return NO;
  }

  return YES;
}

@end
