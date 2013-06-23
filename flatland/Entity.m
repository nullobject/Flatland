//
//  Player.m
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Entity.h"

const CGFloat kMovementSpeed = 100.0f;

@implementation Entity

- (Entity *)init {
  if (self = [super initWithImageNamed:@"Spaceship"]) {
    self.name = [[NSUUID UUID] UUIDString];
    self.state = EntityStateIdle;

    self.scale = 0.25f;

    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.mass = 1.0f;
    self.physicsBody.restitution = 0.2f;
  }

  return self;
}

- (void)forward:(NSTimeInterval)dt {
  CGFloat x = -sinf(self.zRotation) * kMovementSpeed * dt,
          y =  cosf(self.zRotation) * kMovementSpeed * dt;
  [self moveByX:x y:y duration:dt];
}

- (void)reverse:(NSTimeInterval)dt {
  CGFloat x =  sinf(self.zRotation) * kMovementSpeed * dt,
          y = -cosf(self.zRotation) * kMovementSpeed * dt;
  [self moveByX:x y:y duration:dt];
}

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

- (NSDictionary *)asJSON {
  return @{@"id":       self.name,
           @"state":    [self entityStateAsString:self.state],
           @"position": [self pointAsDictionary:self.position],
           @"rotation": [NSNumber numberWithFloat:self.zRotation]};
}

#pragma mark - Private methods

- (void)moveByX:(CGFloat)x y:(CGFloat)y duration:(NSTimeInterval)dt {
  SKAction *action = [SKAction moveByX:x y:y duration:dt];
  [self runAction:action];
}

@end
