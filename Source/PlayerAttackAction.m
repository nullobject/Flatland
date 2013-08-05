//
//  PlayerAttackAction.m
//  Flatland
//
//  Created by Josh Bassett on 17/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Player.h"
#import "PlayerAttackAction.h"

@implementation PlayerAttackAction

- (NSString *)name {
  return @"attack";
}

- (void)applyToPlayer:(Player *)player completion:(void (^)(void))block {
  [player attack:self.duration completion:block];
}

@end
