//
//  World.h
//  flatland
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Core.h"
#import "GameError.h"
#import "Player.h"
#import "Serializable.h"

// TODO: Refactor to a SKNode subclass.
@interface World : SKScene <PlayerDelegate, Serializable, SKPhysicsContactDelegate>

// The players in the simulation.
@property (nonatomic, readonly) NSDictionary *players;

// The age of the world in simulation iterations.
@property (nonatomic, assign) NSUInteger age;

// Enqueues the action for the player with the given UUID.
- (void)enqueueAction:(PlayerAction *)action forPlayer:(NSUUID *)uuid error:(GameError **)error;

// Ticks the world.
- (void)tick;

@end
