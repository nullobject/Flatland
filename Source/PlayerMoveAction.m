//
//  PlayerMoveAction.m
//  Flatland
//
//  Created by Josh Bassett on 17/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Core.h"
#import "Player.h"
#import "PlayerMoveAction.h"

// Movement speed in metres per second.
#define kMovementSpeed 100.0

@implementation PlayerMoveAction

- (CGFloat)cost {
  CGFloat amount = [(NSNumber *)[self.options objectForKey:@"amount"] floatValue];
  CGFloat absAmount = ABS(NORMALIZE(amount));
  return 20 * absAmount;
}

- (void)applyToPlayer:(Player *)player {
  CGFloat amount = [(NSNumber *)[self.options objectForKey:@"amount"] floatValue];

  CGFloat clampedAmount = NORMALIZE(amount),
          x = -sinf(player.rotation) * clampedAmount * kMovementSpeed,
          y =  cosf(player.rotation) * clampedAmount * kMovementSpeed;

  // Calculate the time it takes to move the given amount.
  NSTimeInterval duration = (DISTANCE(x, y) * ABS(clampedAmount)) / kMovementSpeed;

  [player moveByX:x y:y duration:duration];
}

@end
