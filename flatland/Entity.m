//
//  Player.m
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Core.h"
#import "Entity.h"

@implementation Entity

- (Entity *)init {
  if (self = [super initWithImageNamed:@"Spaceship"]) {
    _state = EntityStateIdle;
    
    self.name = [[NSUUID UUID] UUIDString];

    self.scale = 0.25f;

    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.mass = 1.0f;
    self.physicsBody.restitution = 0.2f;
  }

  return self;
}

#pragma mark - Actions

- (void)idle {
  _state = EntityStateIdle;
  NSTimeInterval duration = 1;
  [self runAction:[SKAction waitForDuration:duration]];
}

- (void)moveBy:(CGFloat)amount {
  _state = EntityStateMoving;

  CGFloat clampedAmount = NORMALIZE(amount),
          x = -sinf(self.zRotation) * clampedAmount * kMovementSpeed,
          y =  cosf(self.zRotation) * clampedAmount * kMovementSpeed;

  // Calculate the time it takes to move the given amount.
  NSTimeInterval duration = (DISTANCE(x, y) * ABS(clampedAmount)) / kMovementSpeed;

  [self runAction:[SKAction moveByX:x y:y duration:duration]];
}

- (void)turnBy:(CGFloat)amount {
  _state = EntityStateTurning;

  CGFloat clampedAmount = NORMALIZE(amount),
          angle = clampedAmount * kRotationSpeed;

  // Calculate the time it takes to turn the given amount.
  NSTimeInterval duration = (M_2PI * ABS(clampedAmount)) / kRotationSpeed;

  [self runAction:[SKAction rotateByAngle:angle duration:duration]];
}

#pragma mark - Serializable

- (NSDictionary *)asJSON {
  return @{@"id":              self.name,
           @"state":           [self entityStateAsString:self.state],
           @"age":             [NSNumber numberWithUnsignedInteger:self.age],
           @"energy":          [NSNumber numberWithUnsignedInteger:self.energy],
           @"health":          [NSNumber numberWithUnsignedInteger:self.health],
           @"position":        [self pointAsDictionary:self.position],
           @"rotation":        [NSNumber numberWithFloat:self.zRotation],
           @"velocity":        [self pointAsDictionary:self.physicsBody.velocity],
           @"angularVelocity": [NSNumber numberWithFloat:self.physicsBody.angularVelocity]};
}

#pragma mark - Private

- (NSString *)entityStateAsString:(EntityState) state {
  switch (state) {
    case EntityStateAttacking: return @"attacking";
    case EntityStateMoving:    return @"moving";
    case EntityStateTurning:   return @"turning";
    default:                   return @"idle";
  }
}

- (NSDictionary *)pointAsDictionary:(CGPoint)point {
  return @{@"x": [NSNumber numberWithFloat:point.x],
           @"y": [NSNumber numberWithFloat:point.y]};
}

@end
