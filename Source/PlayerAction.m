//
//  PlayerAction.m
//  Flatland
//
//  Created by Josh Bassett on 2/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "BulletNode.h"
#import "Core.h"
#import "Player.h"
#import "PlayerAction.h"

// Movement speed in metres per second.
#define kMovementSpeed 100.0

// Rotation speed in radians per second.
#define kRotationSpeed M_TAU

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
  // Update the entity energy.
  player.energy += self.cost;
}

@end

@implementation PlayerSpawnAction

- (void)applyToPlayer:(Player *)player {
  NSAssert(player.isDead, @"Player has already spawned");
  NSLog(@"Spawning player %@ in %f seconds.", [player.uuid UUIDString], kSpawnDelay);
  player.state = PlayerStateSpawning;
  SKAction *action = [SKAction sequence:@[[SKAction waitForDuration:kSpawnDelay],
                                          [SKAction performSelector:@selector(didSpawn) onTarget:player]]];
  [player.playerNode runAction:action];
  [super applyToPlayer:player];
}

@end

@implementation PlayerSuicideAction

- (void)applyToPlayer:(Player *)player {
  NSAssert(player.isAlive, @"Player has not spawned");
  NSLog(@"Killing player %@.", [player.uuid UUIDString]);
  SKAction *action = [SKAction performSelector:@selector(didDie) onTarget:player];
  [player.playerNode runAction:action];
  [super applyToPlayer:player];
}

@end

@implementation PlayerIdleAction

- (CGFloat)cost {
  return 10;
}

- (void)applyToPlayer:(Player *)player {
  NSAssert(player.isAlive, @"Player has not spawned");
  NSLog(@"Idling player %@.", [player.uuid UUIDString]);
  [super applyToPlayer:player];
}

@end

@implementation PlayerMoveAction

- (CGFloat)cost {
  CGFloat amount = [(NSNumber *)[self.options objectForKey:@"amount"] floatValue];
  CGFloat absAmount = ABS(NORMALIZE(amount));
  return 20 * absAmount;
}

- (void)applyToPlayer:(Player *)player {
  NSAssert(player.isAlive, @"Player has not spawned");

  CGFloat amount = [(NSNumber *)[self.options objectForKey:@"amount"] floatValue];
  NSLog(@"Moving player %@ by %f.", [player.uuid UUIDString], amount);

  CGFloat clampedAmount = NORMALIZE(amount),
          x = -sinf(player.rotation) * clampedAmount * kMovementSpeed,
          y =  cosf(player.rotation) * clampedAmount * kMovementSpeed;

  // Calculate the time it takes to move the given amount.
  NSTimeInterval duration = (DISTANCE(x, y) * ABS(clampedAmount)) / kMovementSpeed;

  player.state = PlayerStateMoving;

  SKAction *action = [SKAction moveByX:x y:y duration:duration];
  [player.playerNode runAction:action];
  [super applyToPlayer:player];
}

@end

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

@implementation PlayerAttackAction

- (CGFloat)cost {
  return 20;
}

- (void)applyToPlayer:(Player *)player {
  NSAssert(player.isAlive, @"Player has not spawned");
  NSLog(@"Player attacking %@ .", [player.uuid UUIDString]);

  BulletNode *bullet = [[BulletNode alloc] initWithPlayer:player];

  player.state = PlayerStateAttacking;

  [player.playerNode.scene addChild:bullet];
  [super applyToPlayer:player];
}

@end
