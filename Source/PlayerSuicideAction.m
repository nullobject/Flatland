//
//  PlayerSuicideAction.m
//  Flatland
//
//  Created by Josh Bassett on 17/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Player.h"
#import "PlayerSuicideAction.h"

@implementation PlayerSuicideAction

- (NSString *)name {
  return @"suicide";
}

- (void)applyToPlayer:(Player *)player completion:(void (^)(void))block {
  [player suicide:self.duration completion:block];
}

@end
