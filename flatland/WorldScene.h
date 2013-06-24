//
//  MyScene.h
//  flatland
//

//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Serializable.h"

@interface WorldScene : SKScene <Serializable>

// Idles a player with the given UUID.
- (void)idlePlayer:(NSUUID *)uuid;

// Spawns a player with the given UUID.
- (void)spawnPlayer:(NSUUID *)uuid;

// Moves the player with the given UUID forwards.
- (void)movePlayer:(NSUUID *)uuid byAmount:(CGFloat)amount;

// Turns the player with the given UUID.
- (void)turnPlayer:(NSUUID *)uuid byAmount:(CGFloat)amount;

@end
