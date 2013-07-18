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

@interface World : NSObject <Serializable>

// The players in the simulation.
@property (nonatomic, readonly) NSDictionary *players;

// The age of the world in simulation iterations.
@property (nonatomic, assign) NSUInteger age;

// The Sprite Kit node which represents the world.
@property (nonatomic, readonly, strong) WorldNode *worldNode;

// Enqueues the action for the player with the given UUID.
- (void)enqueueAction:(PlayerAction *)action forPlayer:(NSUUID *)uuid error:(GameError **)error;

// Ticks the world.
- (void)tick;

// Called when a player spawned.
- (void)playerDidSpawn:(Player *)player;

- (void)playerDidDie:(Player *)player;

@end
