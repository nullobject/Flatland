//
//  Player.m
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Entity.h"

@implementation Entity

- (Entity *)init {
  if (self = [super initWithImageNamed:@"Spaceship"]) {
    self.name = [[NSUUID UUID] UUIDString];
    self.state = EntityStateIdle;

    self.scale = 0.25f;

    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.mass = 1.0f;
    self.physicsBody.restitution = 0.9f;
  }

  return self;
}

- (NSString *)EntityStateAsString:(EntityState) state {
  switch (state) {
    case EntityStateMoving: return @"moving";
    default:                return @"idle";
  }
}

- (NSDictionary *)asJSON {
  NSDictionary *position = @{@"x": [NSNumber numberWithFloat:self.position.x],
                             @"y": [NSNumber numberWithFloat:self.position.y]};

  return @{@"id":       self.name,
           @"state":    [self EntityStateAsString:self.state],
           @"position": position,
           @"rotation": [NSNumber numberWithFloat:self.zRotation]};
}

@end
