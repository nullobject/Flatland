//
//  MyScene.m
//  flatland
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "NSArray+FP.h"
#import "Player.h"
#import "WorldScene.h"

@implementation WorldScene {
  NSMutableArray *_players;
}

- (id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    _players = [[NSMutableArray alloc] init];

    self.backgroundColor = [SKColor colorWithRed:0.15f green:0.15f blue:0.3f alpha:1.0f];
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

- (void)mouseDown:(NSEvent *)theEvent {
  CGPoint position = [theEvent locationInNode:self];
  [self addShip:position];
}

- (void)addShip:(CGPoint)position {
  Player *player = [[Player alloc] init];

  player.position = position;

//  SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//  [sprite runAction:[SKAction repeatActionForever:action]];

  [_players addObject:player];
  [self addChild:player];
}

- (void)update:(CFTimeInterval)currentTime {
  /* Called before each frame is rendered */
}

- (NSDictionary *)asJSON {
  NSArray *players = [_players map:^(Player *player) {
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
