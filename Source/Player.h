//
//  Player.h
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Entity.h"
#import "GameError.h"
#import "Serializable.h"

// Player spawn delay in seconds.
#define kSpawnDelay 3.0

typedef enum : uint8_t {
  PlayerStateDead,
  PlayerStateSpawning,
  PlayerStateAlive
} PlayerState;

typedef enum : uint8_t {
  PlayerActionTypeSpawn,
  PlayerActionTypeIdle,
  PlayerActionTypeMove,
  PlayerActionTypeTurn
} PlayerActionType;

@class Player;

@protocol PlayerDelegate <NSObject>

- (void)playerDidSpawn:(Player *)player;

@end

@interface PlayerAction : NSObject

@property (nonatomic, assign) PlayerActionType type;
@property (nonatomic, strong) NSDictionary *options;

- (id)initWithType:(PlayerActionType)type andOptions:(NSDictionary *)options;

+ (id)playerActionWithType:(PlayerActionType)type andOptions:(NSDictionary *)options;

@end

@interface Player : NSObject <Serializable>

@property (nonatomic, weak) id <PlayerDelegate> delegate;
@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic, assign) PlayerState state;
@property (nonatomic, strong) Entity *entity;

// Initializes the player with the given UUID.
- (Player *)initWithUUID:(NSUUID *)uuid;

// Enqueues the given action for the player.
- (void)enqueueAction:(PlayerAction *)action error:(GameError **)error;

// Ticks the player.
- (void)tick;

@end
