//
//  BattleScene.h
//  Flatland
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class World;

@interface BattleScene : SKScene <SKPhysicsContactDelegate>

// A weak reference to the world.
@property (nonatomic, weak) World *world;

// Initializes a new battle scene for the given world.
- (BattleScene *)initWithWorld:(World *)world size:(CGSize)size;

@end
