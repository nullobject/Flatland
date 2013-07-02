
//  Player.h
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Serializable.h"

// Entity movement speed in metres per second.
#define kMovementSpeed 100.0

// Entity rotation speed in radians per second.
#define kRotationSpeed M_2PI

#define kIdleCost -10.0f
#define kMoveCost  20.0f
#define kTurnCost  20.0f

typedef enum : uint8_t {
  EntityStateIdle,
  EntityStateAttacking,
  EntityStateMoving,
  EntityStateTurning
} EntityState;

@interface Entity : SKSpriteNode <Serializable>

@property (nonatomic, assign) EntityState state;

// The age of the entity in simulation iterations.
@property (nonatomic, assign) NSUInteger age;

// The energy of the entity. It costs the entity energy to perform actions.
@property (nonatomic, assign) CGFloat energy;

// The health of the entity. When health reaches zero, then the entity is dead.
@property (nonatomic, assign) CGFloat health;

// Initializes a new entity.
- (Entity *)init;

// Commands.
- (void)idle;
- (void)moveBy:(CGFloat)amount;
- (void)turnBy:(CGFloat)amount;

@end
