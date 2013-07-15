//
//  BulletNode.h
//  Flatland
//
//  Created by Josh Bassett on 4/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Collidable.h"
#import "Core.h"
#import "PlayerNode.h"

// Represents a projectile fired by an entity.
@interface BulletNode : SKSpriteNode <Collidable>

// The player who shot the bullet.
@property (nonatomic, readonly, weak) Player *player;

// Initializes a new bullet for the given player.
- (BulletNode *)initWithPlayer:(Player *)player;

@end
