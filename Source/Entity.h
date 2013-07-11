
//  Player.h
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Collidable.h"
#import "Core.h"
#import "Serializable.h"

typedef enum : uint8_t {
  EntityStateIdle,
  EntityStateAttacking,
  EntityStateMoving,
  EntityStateTurning
} EntityState;

@class Entity;

@protocol EntityDelegate <NSObject>

- (void)entity:(Entity *)entity didKill:(Entity *)other;
- (void)entity:(Entity *)entity wasKilledBy:(Entity *)other;

@end

@interface Entity : SKSpriteNode <Collidable, Serializable>

@property (nonatomic, weak) id <EntityDelegate> delegate;
@property (nonatomic, readonly, strong) NSUUID *uuid;
@property (nonatomic, readonly) EntityState state;

// The age of the entity in simulation iterations.
@property (nonatomic, assign) NSUInteger age;

// The energy of the entity. It costs the entity energy to perform actions.
@property (nonatomic, assign) CGFloat energy;

// The health of the entity. When health reaches zero, then the entity is dead.
@property (nonatomic, assign) CGFloat health;

// Initializes a new entity.
- (Entity *)initWithUUID:(NSUUID *)uuid;

// Commands.
- (void)idle;
- (void)moveBy:(CGFloat)amount;
- (void)turnBy:(CGFloat)amount;
- (void)attack;

@end
