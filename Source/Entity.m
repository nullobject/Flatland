//
//  Player.m
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Bullet.h"
#import "Core.h"
#import "Entity.h"
#import "NSDictionary+Point.h"

// Movement speed in metres per second.
#define kMovementSpeed 100.0

// Rotation speed in radians per second.
#define kRotationSpeed M_TAU

@implementation Entity

- (Entity *)initWithUUID:(NSUUID *)uuid {
  if (self = [super initWithImageNamed:@"player"]) {
    _uuid   = uuid;
    _state  = EntityStateIdle;
    _age    = 0;
    _energy = 100.0f;
    _health = 100.0f;

    self.name = [uuid UUIDString];
    self.scale = 2.0f;
    self.physicsBody = [self setupPhysicsBody:self.size];
  }

  return self;
}

- (void)setEnergy:(CGFloat)energy {
  _energy = CLAMP(energy, 0.0f, 100.0f);
}

- (void)setHealth:(CGFloat)health {
  _health = CLAMP(health, 0.0f, 100.0f);
}

#pragma mark - Actions

- (void)idle {
  NSTimeInterval duration = 1;

  _state = EntityStateIdle;

  [self runAction:[SKAction waitForDuration:duration]];
}

- (void)moveBy:(CGFloat)amount {
  CGFloat clampedAmount = NORMALIZE(amount),
          x = -sinf(self.zRotation) * clampedAmount * kMovementSpeed,
          y =  cosf(self.zRotation) * clampedAmount * kMovementSpeed;

  // Calculate the time it takes to move the given amount.
  NSTimeInterval duration = (DISTANCE(x, y) * ABS(clampedAmount)) / kMovementSpeed;

  _state = EntityStateMoving;

  [self runAction:[SKAction moveByX:x y:y duration:duration]];
}

- (void)turnBy:(CGFloat)amount {
  CGFloat clampedAmount = NORMALIZE(amount),
          angle = clampedAmount * kRotationSpeed;

  // Calculate the time it takes to turn the given amount.
  NSTimeInterval duration = (M_TAU * ABS(clampedAmount)) / kRotationSpeed;

  _state = EntityStateTurning;

  [self runAction:[SKAction rotateByAngle:angle duration:duration]];
}

- (void)attack {
  Bullet *bullet = [[Bullet alloc] initWithEntity:self];

  _state = EntityStateAttacking;

  [self.scene addChild:bullet];
}

#pragma mark - Collidable

- (void)didCollideWith:(SKPhysicsBody *)body {
  NSLog(@"Entity#didCollideWith %@", body);
  if ([body.node isMemberOfClass:Bullet.class]) {
    [self shotByBullet:(Bullet *)body.node];
  }
}

#pragma mark - Serializable

- (NSDictionary *)asJSON {
  return @{@"id":              self.name,
           @"state":           [Entity stateAsString:self.state],
           @"age":             [NSNumber numberWithUnsignedInteger:self.age],
           @"energy":          [NSNumber numberWithFloat:self.energy],
           @"health":          [NSNumber numberWithFloat:self.health],
           @"position":        [NSDictionary dictionaryWithPoint:self.position],
           @"rotation":        [NSNumber numberWithFloat:self.zRotation],
           @"velocity":        [NSDictionary dictionaryWithPoint:self.physicsBody.velocity],
           @"angularVelocity": [NSNumber numberWithFloat:self.physicsBody.angularVelocity]};
}

#pragma mark - Private

- (SKPhysicsBody *)setupPhysicsBody:(CGSize)size {
  SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];

  // Set the physical properties.
  physicsBody.mass = 1.0f;
  physicsBody.restitution = 0.2f;

  // Set the collision bit masks.
  physicsBody.categoryBitMask    = ColliderTypeEntity;
  physicsBody.collisionBitMask   = ColliderTypeWall | ColliderTypeEntity;
  physicsBody.contactTestBitMask = ColliderTypeBullet;

  return physicsBody;
}

+ (NSString *)stateAsString:(EntityState) state {
  switch (state) {
    case EntityStateAttacking: return @"attacking";
    case EntityStateMoving:    return @"moving";
    case EntityStateTurning:   return @"turning";
    default:                   return @"idle";
  }
}

- (void)shotByBullet:(Bullet *)bullet {
  // An entity can't shoot themselves.
  if (self == bullet.shooter) return;

  // Apply damage.
  self.health -= 10.0f;

  // If the entity was killed then notify both the deceased and the shooter.
  if (_health == 0.0f) {
    [bullet.shooter.delegate didKill:self];
    [_delegate wasKilledBy:bullet.shooter];
  }
}

@end
