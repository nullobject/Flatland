//
//  Action.h
//  flatland
//
//  Created by Josh Bassett on 29/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

// Represents a player action.
@interface Action : NSObject

@property (nonatomic, strong) NSUUID *uuid;

- (id)initWithPlayer:(NSUUID *)uuid;

@end

// Spawns a player.
@interface SpawnAction : Action
@end

// Idles a player.
@interface IdleAction : Action
@end

// Moves a player in the current direction by an amount.
@interface MoveAction : Action

@property (nonatomic, assign) CGFloat amount;

- (id)initWithPlayer:(NSUUID *)uuid andAmount:(CGFloat)amount;

@end

// Turns a player by an amount.
@interface TurnAction : Action

@property (nonatomic, assign) CGFloat amount;

- (id)initWithPlayer:(NSUUID *)uuid andAmount:(CGFloat)amount;

@end
