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

typedef enum : uint8_t {
  PlayerStateAttacking,
  PlayerStateDead,
  PlayerStateMoving,
  PlayerStateResting,
  PlayerStateSpawning,
  PlayerStateTurning
} PlayerState;

@class World;

@interface Player : NSObject <Serializable>

// A reference to the world.
@property (nonatomic, weak) World *world;

// The Sprite Kit node which represents the player.
@property (nonatomic, readonly) PlayerNode *playerNode;

// The unique identifier for the player.
@property (nonatomic, readonly) NSUUID *uuid;

@property (nonatomic, readonly) PlayerState state;
@property (nonatomic, readonly) NSUInteger  age;
@property (nonatomic, readonly) CGFloat     energy;
@property (nonatomic, readonly) CGFloat     health;
@property (nonatomic, readonly) NSUInteger  deaths;
@property (nonatomic, readonly) NSUInteger  kills;
@property (nonatomic, readonly) CGPoint     position;
@property (nonatomic, readonly) CGFloat     rotation;
@property (nonatomic, readonly) CGPoint     velocity;
@property (nonatomic, readonly) CGFloat     angularVelocity;

@property (nonatomic, readonly) BOOL isAlive;
@property (nonatomic, readonly) BOOL isSpawning;

// Initializes the player with the given UUID.
- (Player *)initWithUUID:(NSUUID *)uuid;

// Applies the given action to the player.
- (BOOL)applyAction:(PlayerAction *)action completion:(void (^)(void))block error:(GameError **)error;

// Ticks the player.
- (void)tick;

// Spawns the player.
- (void)spawn:(NSTimeInterval)duration completion:(void (^)(void))block;

// Rests the player.
- (void)rest:(NSTimeInterval)duration completion:(void (^)(void))block;

// Fires a bullet in the current direction.
- (void)attack:(NSTimeInterval)duration completion:(void (^)(void))block;

// Moves the player by the X/Y offsets over the given duration.
- (void)moveByX:(CGFloat)x y:(CGFloat)y duration:(NSTimeInterval)duration completion:(void (^)(void))block;

// Rotates the player by the angle over the given duration.
- (void)rotateByAngle:(CGFloat)angle duration:(NSTimeInterval)duration completion:(void (^)(void))block;

// Kills the player.
- (void)suicide:(NSTimeInterval)duration completion:(void (^)(void))block;

// Called when the player spawns.
- (void)didSpawn;

// Called when the player was shot by another player.
- (void)wasShotByPlayer:(Player *)player;

// Called when the player died.
- (void)didDie;

@end
