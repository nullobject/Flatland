//
//  BulletNode.m
//  Flatland
//
//  Created by Josh Bassett on 4/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "BulletNode.h"
#import "Player.h"

// Movement speed in metres per second.
#define kMovementSpeed 500.0

@implementation BulletNode

- (BulletNode *)initWithPlayer:(Player *)player {
  if (self = [super initWithImageNamed:@"bullet"]) {
    _player = player;

    CGFloat x = player.playerNode.position.x + (-sinf(player.playerNode.zRotation) * player.playerNode.size.width),
            y = player.playerNode.position.y + (cosf(player.playerNode.zRotation) * player.playerNode.size.height);

    self.position = CGPointMake(x, y);
    self.zRotation = player.playerNode.zRotation;
    self.physicsBody = [self setupPhysicsBody:self.size];
    self.physicsBody.velocity = CGPointMake(-sinf(player.playerNode.zRotation) * kMovementSpeed,
                                            cosf(player.playerNode.zRotation) * kMovementSpeed);
  }

  return self;
}

#pragma mark - Collidable

- (void)didCollideWith:(SKPhysicsBody *)body {
  // Remove the bullet when it contacts something.
  [self removeFromParent];
}

#pragma mark - Private

- (SKPhysicsBody *)setupPhysicsBody:(CGSize)size {
  SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];

  // Set the physical properties.
  physicsBody.mass = 0.1f;
  physicsBody.restitution = 0.8f;

  // Set the collision bit masks.
  physicsBody.categoryBitMask    = ColliderTypeBullet;
  physicsBody.collisionBitMask   = ColliderTypeWall | ColliderTypeEntity;
  physicsBody.contactTestBitMask = ColliderTypeWall | ColliderTypeEntity;

  return physicsBody;
}

@end
