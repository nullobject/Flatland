//
//  PlayerAction.m
//  Flatland
//
//  Created by Josh Bassett on 2/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "NSBundle+InfoDictionaryKeyPath.h"
#import "Player.h"
#import "PlayerAction.h"
#import "PlayerSpawnAction.h"

@implementation PlayerAction

- (NSString *)name {
  return @"";
}

- (id)initWithOptions:(NSDictionary *)options {
  if (self = [super init]) {
    _cost     = [self getCost];
    _duration = [self getDuration];
    _options  = options;
  }

  return self;
}

- (void)applyToPlayer:(Player *)player completion:(void (^)(void))block {
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

#pragma mark - Private

- (CGFloat)getCost {
  NSString *keyPath = [NSString stringWithFormat:@"Actions.%@.Cost", [self.name capitalizedString]];
  NSNumber *cost = [[NSBundle bundleForClass:self.class] objectForInfoDictionaryKeyPath:keyPath];
  return [cost doubleValue];
}

- (NSTimeInterval)getDuration {
  NSString *keyPath = [NSString stringWithFormat:@"Actions.%@.Duration", [self.name capitalizedString]];
  NSNumber *cost = [[NSBundle bundleForClass:self.class] objectForInfoDictionaryKeyPath:keyPath];
  return [cost doubleValue];
}

@end
