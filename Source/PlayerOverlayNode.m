//
//  PlayerOverlayNode.m
//  Flatland
//
//  Created by Josh Bassett on 11/08/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "BarNode.h"
#import "Core.h"
#import "Player.h"
#import "PlayerOverlayNode.h"

@implementation PlayerOverlayNode {
  BarNode *_healthNode;
  BarNode *_energyNode;
  SKLabelNode *_nameNode;
}

- (PlayerOverlayNode *)initWithPlayer:(Player *)player {
  if (self = [super init]) {
    _player = player;

    self.name = [player.uuid UUIDString];

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
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

#pragma mark - Private

- (SKLabelNode *)labelNodeWithText:(NSString *)text {
  SKLabelNode *node = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica"];
  node.fontSize = 12.0f;
  node.fontColor = [SKColor whiteColor];
  node.text = text;
  return node;
}

@end
