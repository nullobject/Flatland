//
//  Player.h
//  Flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GameError.h"
#import "PlayerAction.h"
#import "PlayerNode.h"
#import "Serializable.h"

// Player spawn delay in seconds.
#define kSpawnDelay 3.0

typedef enum : uint8_t {
  PlayerStateDead,
  PlayerStateSpawning,
  PlayerStateIdle,
  PlayerStateAttacking,
  PlayerStateMoving,
  PlayerStateTurning
} PlayerState;

@class World;

@interface Player : NSObject <Serializable>

// A reference to the world.
@property (nonatomic, weak) World *world;

// The player UUID.
@property (nonatomic, readonly, strong) NSUUID *uuid;

// The player state.
@property (nonatomic, assign) PlayerState state;

// The Sprite Kit node which represents the player.
@property (nonatomic, readonly, strong) PlayerNode *playerNode;

@property (nonatomic, readonly) BOOL isAlive;
@property (nonatomic, readonly) BOOL isDead;
@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, readonly) CGFloat rotation;
@property (nonatomic, readonly) CGPoint velocity;
@property (nonatomic, readonly) CGFloat angularVelocity;

// The number of times the player has died.
@property (nonatomic, readonly) NSUInteger deaths;

// The number of times the player has killed another player.
@property (nonatomic, readonly) NSUInteger kills;

// The age of the entity in simulation iterations.
@property (nonatomic, assign) NSUInteger age;

// The energy of the entity. It costs the entity energy to perform actions.
@property (nonatomic, assign) CGFloat energy;

// The health of the entity. When health reaches zero, then the entity is dead.
@property (nonatomic, assign) CGFloat health;

// Initializes the player with the given UUID.
- (Player *)initWithUUID:(NSUUID *)uuid;

// Enqueues the given action for the player.
- (void)enqueueAction:(PlayerAction *)action error:(GameError **)error;

// Ticks the player.
- (void)tick;

- (void)didSpawn;
- (void)didDie;

// Called when the player was shot by another player.
- (void)wasShotByPlayer:(Player *)player;

// Called when the player kills another player.
- (void)didKillPlayer:(Player *)player;

// Called when the player was killed by another player.
- (void)wasKilledByPlayer:(Player *)player;

@end
