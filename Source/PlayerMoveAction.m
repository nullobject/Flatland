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

- (NSString *)name {
  return @"move";
}

- (CGFloat)cost {
  CGFloat amount = [(NSNumber *)[self.options objectForKey:@"amount"] floatValue];
  return super.cost * ABS(NORMALIZE(amount));
}

- (void)applyToPlayer:(Player *)player completion:(void (^)(void))block {
  CGFloat amount = [(NSNumber *)[self.options objectForKey:@"amount"] floatValue];

  CGFloat clampedAmount = NORMALIZE(amount),
          x = -sinf(player.rotation) * clampedAmount * kMovementSpeed,
          y =  cosf(player.rotation) * clampedAmount * kMovementSpeed;

  // Calculate the time it takes to move the given amount.
  NSTimeInterval duration = self.duration * (DISTANCE(x, y) * ABS(clampedAmount)) / kMovementSpeed;

  [player moveByX:x y:y duration:duration completion:block];
}

@end
