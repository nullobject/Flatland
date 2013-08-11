
//  PlayerNode.h
//  Flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Collidable.h"

@class Player;

// Represents an entity in the world, controlled by a player.
@interface PlayerNode : SKSpriteNode <Collidable>

// The player who owns the player node.
@property (nonatomic, weak) Player *player;

// Initializes a new player node for the given player.
- (PlayerNode *)initWithPlayer:(Player *)player;

@end
