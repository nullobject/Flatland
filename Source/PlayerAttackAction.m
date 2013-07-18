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

- (CGFloat)cost {
  return 20;
}

- (void)applyToPlayer:(Player *)player {
  [player attack];
}

@end
