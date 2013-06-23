//
//  MyScene.m
//  flatland
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "NSArray+FP.h"
#import "SKColor+Relative.h"
#import "Entity.h"
#import "Player.h"
#import "WorldScene.h"

@implementation WorldScene {
  NSMutableArray *_players;
}

- (id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    _players = [[NSMutableArray alloc] init];

    self.backgroundColor = [SKColor colorWithRGB:0xffa000];
    self.physicsWorld.gravity = CGPointMake(0.0f, -9.8f);

    [self addWalls];
  }

  return self;
}

- (void)addWalls {
  [self addCollisionWallAtWorldPoint:CGPointMake(0.0f, 0.0f) withWidth:self.frame.size.width height:1.0f];
  [self addCollisionWallAtWorldPoint:CGPointMake(0.0f, 0.0f) withWidth:1.0f height:self.frame.size.height];
  [self addCollisionWallAtWorldPoint:CGPointMake(0.0f, self.frame.size.height) withWidth:self.frame.size.width height:1.0f];
  [self addCollisionWallAtWorldPoint:CGPointMake(self.frame.size.width, 0.0f) withWidth:1.0f height:self.frame.size.height];
}

- (void)addCollisionWallAtWorldPoint:(CGPoint)worldPoint
                           withWidth:(CGFloat)width height:(CGFloat)height {
  CGRect rect = CGRectMake(0, 0, width, height);
  SKNode *wallNode = [SKNode node];
  wallNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rect.size];
  wallNode.position = CGPointMake(worldPoint.x + rect.size.width * 0.5,
                                  worldPoint.y + rect.size.height * 0.5);
  wallNode.physicsBody.dynamic = NO;
  wallNode.physicsBody.friction = 1.0f;

  [self addChild:wallNode];
}

- (void)spawn:(NSUUID *)UUID {
  Player *player = [[Player alloc] initWithUUID:UUID];
  [_players addObject:player];
  [self addChild:player.entity];
}

- (void)update:(CFTimeInterval)currentTime {
  /* Called before each frame is rendered */
}

- (NSDictionary *)asJSON {
  NSArray *players = [_players map:^(Entity *player) {
    return [player asJSON];
  }];

  return @{@"players": players};
}

- (NSData *)toJSON {
  NSError *error;
  return [NSJSONSerialization dataWithJSONObject:[self asJSON]
                                         options:NSJSONWritingPrettyPrinted
                                           error:&error];
}

@end
