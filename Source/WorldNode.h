//
//  WorldNode.h
//  Flatland
//
//  Created by Josh Bassett on 15/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class World;

@interface WorldNode : SKNode

// The world which owns the world node.
@property (nonatomic, weak) World *world;

// Initializes a new world node.
- (WorldNode *)initWithWorld:(World *)world;

@end
