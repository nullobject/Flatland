//
//  Player.h
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : uint8_t {
  PlayerStateIdle,
  PlayerStateMoving
} PlayerState;

@interface Player : SKSpriteNode

@property (nonatomic, assign) PlayerState state;

- (Player *)init;
- (NSDictionary *)asJSON;

@end
