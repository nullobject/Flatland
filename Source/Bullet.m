//
//  Bullet.m
//  Flatland
//
//  Created by Josh Bassett on 4/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Bullet.h"

// Movement speed in metres per second.
#define kMovementSpeed 500.0

@implementation Bullet

- (Bullet *)initWithEntity:(Entity *)entity {
  if (self = [super initWithImageNamed:@"bullet"]) {
    _owner = entity;

    self.scale = 2.0f;

    CGFloat x = entity.position.x + (-sinf(entity.zRotation) * entity.size.width),
            y = entity.position.y + (cosf(entity.zRotation) * entity.size.height);

    self.position = CGPointMake(x, y);
    self.zRotation = entity.zRotation;

    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.velocity = CGPointMake(-sinf(entity.zRotation) * kMovementSpeed,
                                            cosf(entity.zRotation) * kMovementSpeed);

    // Set the physical properties.
    self.physicsBody.mass = 0.1f;
    self.physicsBody.restitution = 0.8f;

    // Set the collision bit masks.
    self.physicsBody.categoryBitMask    = ColliderTypeBullet;
    self.physicsBody.collisionBitMask   = ColliderTypeWall | ColliderTypeEntity;
    self.physicsBody.contactTestBitMask = ColliderTypeWall | ColliderTypeEntity;
  }

  return self;
}

#pragma mark - Collidable

- (void)didCollideWith:(SKPhysicsBody *)body {
  NSLog(@"Bullet#didCollideWith %@", body);
  [self removeFromParent];
}

@end
