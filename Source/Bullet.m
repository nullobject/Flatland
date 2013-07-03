//
//  Bullet.m
//  Flatland
//
//  Created by Josh Bassett on 4/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Bullet.h"

@implementation Bullet

- (Bullet *)initWithEntity:(NSUUID *)uuid {
  if (self = [super initWithImageNamed:@"bullet"]) {
    _uuid = uuid;

    self.scale = 2.0f;

    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.mass = 0.1f;
    self.physicsBody.restitution = 0.8f;
  }

  return self;
}

@end
