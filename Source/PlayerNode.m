//
//  PlayerNode.m
//  Flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "BarNode.h"
#import "BulletNode.h"
#import "Core.h"
#import "Player.h"
#import "PlayerNode.h"

// Movement speed in metres per second.
#define kMovementSpeed 100.0

// Rotation speed in radians per second.
#define kRotationSpeed M_TAU

@implementation PlayerNode {
  BarNode *_healthNode;
  BarNode *_energyNode;
  SKLabelNode *_nameNode;
}

- (PlayerNode *)initWithPlayer:(Player *)player {
  if (self = [super initWithImageNamed:@"player"]) {
    _player = player;

    [_player addObserver:self forKeyPath:@"energy" options:NSKeyValueObservingOptionNew context:nil];
    [_player addObserver:self forKeyPath:@"health" options:NSKeyValueObservingOptionNew context:nil];

    self.name = [player.uuid UUIDString];
    self.physicsBody = [self setupPhysicsBody:self.size];

    _healthNode = [[BarNode alloc] initWithSize:CGSizeMake(20, 2) color:[SKColor greenColor]];
    _healthNode.position = CGPointMake(0.0f, -25.0f);
    [self addChild:_healthNode];

    _energyNode = [[BarNode alloc] initWithSize:CGSizeMake(20, 2) color:[SKColor redColor]];
    _energyNode.position = CGPointMake(0.0f, -30.0f);
    [self addChild:_energyNode];

    _nameNode = [self labelNodeWithText:self.name];
    _nameNode.position = CGPointMake(0.0f, 30.0f);
    [self addChild:_nameNode];
  }

  return self;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqualToString:@"energy"]) {
    _energyNode.value = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
  } else if ([keyPath isEqualToString:@"health"]) {
    _healthNode.value = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
  }
}

#pragma mark - Collidable

- (void)didCollideWith:(SKPhysicsBody *)body {
  NSLog(@"Entity#didCollideWith %@", body);

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
- (SKLabelNode *)labelNodeWithText:(NSString *)text {
  SKLabelNode *node = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica"];
  node.fontSize = 12.0f;
  node.fontColor = [SKColor whiteColor];
  node.text = text;
  return node;
}

@end
