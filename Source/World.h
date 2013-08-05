//
//  World.h
//  Flatland
//
//  Created by Josh Bassett on 15/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Serializable.h"
#import "WorldNode.h"

@class BulletNode, GameError, Player, PlayerAction;

@interface World : NSObject <Serializable>

// The Sprite Kit node which represents the world.
@property (nonatomic, readonly) WorldNode *worldNode;

// The players in the simulation.
@property (nonatomic, readonly) NSDictionary *players;

// The age of the world in simulation iterations.
@property (nonatomic) NSUInteger age;

// Enqueues the action for the given player.
- (BOOL)enqueueAction:(PlayerAction *)action forPlayer:(NSUUID *)uuid completion:(void (^)(void))block error:(GameError **)error;

// Ticks the world.
- (void)tick;

// Called when a player spawns.
- (void)playerDidSpawn:(Player *)player;

// Called when a player dies.
- (void)playerDidDie:(Player *)player;

// Called when a player shoots a bullet.
- (void)player:(Player *)player didShootBullet:(BulletNode *)bulletNode;

@end
