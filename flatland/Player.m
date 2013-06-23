//
//  Player.m
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Player.h"

@implementation Player

- (Player *)init {
  if (self = [super initWithImageNamed:@"Spaceship"]) {
    self.name = [[NSUUID UUID] UUIDString];
    self.scale = 0.25f;

    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.mass = 1.0f;
    self.physicsBody.restitution = 0.9f;
  }

  return self;
}

- (NSDictionary *)asJSON {
  NSDictionary *position = @{@"x": [NSNumber numberWithFloat:self.position.x],
                             @"y": [NSNumber numberWithFloat:self.position.y]};

  return @{@"name":     self.name,
           @"position": position,
           @"rotation": [NSNumber numberWithFloat:self.zRotation]};
}

@end
