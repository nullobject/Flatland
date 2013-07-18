//
//  PlayerAction.h
//  Flatland
//
//  Created by Josh Bassett on 2/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GameError.h"

@class Player;

// Represents an action submitted by a player.
@interface PlayerAction : NSObject

@property (nonatomic, readonly) NSDictionary *options;

// The cost to perform the action (in energy units).
@property (nonatomic, readonly) CGFloat cost;

- (id)initWithOptions:(NSDictionary *)options;

// Applies the action to the given player.
- (void)applyToPlayer:(Player *)player;

// Validates the action for the given player.
- (BOOL)validateForPlayer:(Player *)player error:(GameError **)error;

@end
