//
//  Bullet.h
//  Flatland
//
//  Created by Josh Bassett on 4/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Collidable.h"
#import "Core.h"
#import "Entity.h"

@interface Bullet : SKSpriteNode <Collidable>

@property (nonatomic, readonly, weak) Entity *owner;

// Initializes a new bullet for the given entity.
- (Bullet *)initWithEntity:(Entity *)entity;

@end
