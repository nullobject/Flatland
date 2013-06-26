
//  Player.h
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Serializable.h"

typedef enum : uint8_t {
  EntityStateIdle,
  EntityStateAttacking,
  EntityStateMoving,
  EntityStateTurning
} EntityState;

@interface Entity : SKSpriteNode <Serializable>

@property (nonatomic, assign) EntityState state;
@property (nonatomic, assign) NSUInteger age;

- (Entity *)init;

// Commands.
- (void)idle;
- (void)moveBy:(CGFloat)amount;
- (void)turnBy:(CGFloat)amount;

@end
