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
  NSAssert(player.isAlive, @"Player has not spawned");

  CGFloat amount = [(NSNumber *)[self.options objectForKey:@"amount"] floatValue];
  NSLog(@"Turning player %@ by %f.", [player.uuid UUIDString], amount);

  CGFloat clampedAmount = NORMALIZE(amount),
          angle = clampedAmount * kRotationSpeed;

  // Calculate the time it takes to turn the given amount.
  NSTimeInterval duration = (M_TAU * ABS(clampedAmount)) / kRotationSpeed;

  player.state = PlayerStateTurning;

  SKAction *action = [SKAction rotateByAngle:angle duration:duration];
  [player.playerNode runAction:action];
  [super applyToPlayer:player];
}

@end
