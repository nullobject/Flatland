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
  NSMutableDictionary *_players;
}

- (id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    _players = [[NSMutableDictionary alloc] init];

    self.backgroundColor = [SKColor colorWithRGB:0xffa000];
    self.physicsWorld.gravity = CGPointMake(0.0f, 0.0f);

    [self addWalls];
  }

  return self;
}

- (void)addWalls {
  [self addCollisionWallAtPoint:CGPointMake(0.0f, 0.0f) withWidth:self.frame.size.width height:1.0f];
  [self addCollisionWallAtPoint:CGPointMake(0.0f, 0.0f) withWidth:1.0f height:self.frame.size.height];
  [self addCollisionWallAtPoint:CGPointMake(0.0f, self.frame.size.height) withWidth:self.frame.size.width height:1.0f];
  [self addCollisionWallAtPoint:CGPointMake(self.frame.size.width, 0.0f) withWidth:1.0f height:self.frame.size.height];
}

- (void)addCollisionWallAtPoint:(CGPoint)point
                      withWidth:(CGFloat)width
                         height:(CGFloat)height {
  CGRect rect = CGRectMake(0, 0, width, height);
  SKNode *wallNode = [SKNode node];
  wallNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rect.size];
  wallNode.position = CGPointMake(point.x + rect.size.width * 0.5, point.y + rect.size.height * 0.5);
  wallNode.physicsBody.dynamic = NO;
  wallNode.physicsBody.friction = 0.2f;
  [self addChild:wallNode];
}

- (Player *)playerWithUUID:(NSUUID *)uuid {
  Player *player = [_players objectForKey:uuid];

  if (player == nil) {
    player = [[Player alloc] initWithUUID:uuid];
    [_players setObject:player forKey:player.uuid];
  }

  return player;
}

- (void)idlePlayer:(NSUUID *)uuid {
  Player *player = [self playerWithUUID:uuid];
  [player idle];
}

- (void)spawnPlayer:(NSUUID *)uuid {
  Player *player = [self playerWithUUID:uuid];
  [player spawn];
  [self addChild:player.entity];
}

- (void)movePlayer:(NSUUID *)uuid byAmount:(CGFloat)amount {
  Player *player = [self playerWithUUID:uuid];
  [player moveBy:amount];
}

- (void)turnPlayer:(NSUUID *)uuid byAmount:(CGFloat)amount {
  Player *player = [self playerWithUUID:uuid];
  [player turnBy:amount];
}

- (void)update:(CFTimeInterval)currentTime {
  /* Called before each frame is rendered */
}

- (NSDictionary *)asJSON {
  NSArray *players = [_players.allValues map:^(Entity *player) {
    return [player asJSON];
  }];

  return @{@"players": players};
}

@end