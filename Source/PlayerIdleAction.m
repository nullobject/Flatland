//
//  PlayerIdleAction.m
//  Flatland
//
//  Created by Josh Bassett on 17/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Player.h"
#import "PlayerIdleAction.h"

@implementation PlayerIdleAction

- (CGFloat)cost {
  return -10;
}

- (void)applyToPlayer:(Player *)player {
  [player idle];
}

@end
