//
//  Player.m
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Entity.h"

// Clamps X between A and B (where a <= n <= b).
#define CLAMP(X, A, B) MAX(A, MIN(X, B))

#define NORMALIZE(X) CLAMP(X, -1.0, 1.0)

const CGFloat kMovementSpeed = 100.0f; // Metres per second.
const CGFloat kRotationSpeed = 2.0f * M_PI; // Radians per second.

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

- (void)idle {
  _state = EntityStateIdle;
}

- (void)moveBy:(CGFloat)amount {
  CGFloat clampedAmount = NORMALIZE(amount),
          x = -sinf(self.zRotation) * clampedAmount * kMovementSpeed,
          y =  cosf(self.zRotation) * clampedAmount * kMovementSpeed;
  NSTimeInterval duration = (sqrt(pow(x, 2) + pow(y, 2))  * clampedAmount) / kMovementSpeed;
  SKAction *action = [SKAction moveByX:x y:y duration:duration];
  [self runAction:action];
  _state = EntityStateMoving;
}

- (void)turnBy:(CGFloat)amount {
  CGFloat clampedAmount = NORMALIZE(amount),
          angle = clampedAmount * kRotationSpeed;
  NSTimeInterval duration = (2.0f * M_PI * clampedAmount) / kRotationSpeed;
  SKAction *action = [SKAction rotateByAngle:angle duration:duration];
  [self runAction:action];
  _state = EntityStateTurning;
}

- (NSDictionary *)asJSON {
  return @{@"id":       self.name,
           @"state":    [self entityStateAsString:self.state],
           @"position": [self pointAsDictionary:self.position],
           @"rotation": [NSNumber numberWithFloat:self.zRotation]};
}

#pragma mark - Private methods

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
