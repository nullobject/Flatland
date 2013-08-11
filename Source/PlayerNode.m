//
//  PlayerNode.m
//  Flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "BulletNode.h"
#import "Player.h"
#import "PlayerNode.h"

@implementation PlayerNode

- (PlayerNode *)initWithPlayer:(Player *)player {
  if (self = [super initWithImageNamed:@"player"]) {
    _player = player;

    self.name = [player.uuid UUIDString];
    self.physicsBody = [self setupPhysicsBody:self.size];
    self.position = CGPointMake(RANDOM() * 500, RANDOM() * 500);
  }

  return self;
}

#pragma mark - Collidable

- (void)didCollideWith:(SKPhysicsBody *)body {
  NSLog(@"PlayerNode#didCollideWith %@", body);

  if ([body.node isMemberOfClass:BulletNode.class]) {
    BulletNode *bulletNode = (BulletNode *)body.node;
    [_player wasShotByPlayer:bulletNode.player];
  }
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

@end
