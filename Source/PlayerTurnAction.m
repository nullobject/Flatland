//
//  PlayerTurnAction.m
//  Flatland
//
//  Created by Josh Bassett on 17/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Core.h"
#import "Player.h"
#import "PlayerTurnAction.h"

// Rotation speed in radians per second.
#define kRotationSpeed M_TAU

@implementation PlayerTurnAction

- (CGFloat)cost {
  CGFloat amount = [(NSNumber *)[self.options objectForKey:@"amount"] floatValue];
  CGFloat absAmount = ABS(NORMALIZE(amount));
  return 20 * absAmount;
}

- (void)applyToPlayer:(Player *)player {
  CGFloat amount = [(NSNumber *)[self.options objectForKey:@"amount"] floatValue];

  CGFloat clampedAmount = NORMALIZE(amount),
          angle = clampedAmount * kRotationSpeed;

  // Calculate the time it takes to turn the given amount.
  NSTimeInterval duration = (M_TAU * ABS(clampedAmount)) / kRotationSpeed;

  [player rotateByAngle:angle duration:duration];
}

@end
