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

- (void)runAction:(Action *)action forPlayer:(NSUUID *)uuid {
  Player *player = [self playerWithUUID:uuid];
  [player runAction:action];
}

- (void)update:(CFTimeInterval)currentTime {
  /* Called before each frame is rendered */
}

#pragma mark - Serializable

- (NSDictionary *)asJSON {
  NSArray *players = [_players.allValues map:^(Player *player) {
    return [player asJSON];
  }];

  return @{@"age":     [NSNumber numberWithUnsignedInteger:self.age],
           @"players": players};
}

#pragma mark - PlayerDelegate

- (void)playerDidSpawn:(Player *)player {
  [self addChild:player.entity];
}

#pragma mark - Private

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

// Returns the player with the given UUID, if the player doesn't exist then one
// is created.
- (Player *)playerWithUUID:(NSUUID *)uuid {
  Player *player = [_players objectForKey:uuid];

  if (player == nil) {
    player = [[Player alloc] initWithUUID:uuid];
    player.delegate = self;
    [_players setObject:player forKey:player.uuid];
  }

  return player;
}

@end
