//
//  PlayerOverlayNode.h
//  Flatland
//
//  Created by Josh Bassett on 11/08/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Player;

@interface PlayerOverlayNode : SKNode

// The player who owns the player overlay node.
@property (nonatomic, weak) Player *player;

// Initializes a new player overlay node for the given player.
- (PlayerOverlayNode *)initWithPlayer:(Player *)player;

@end
