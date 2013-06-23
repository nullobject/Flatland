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
- (void)idle:(NSUUID *)UUID;

// Spawns a player with the given UUID.
- (void)spawn:(NSUUID *)UUID;

// Moves the player with the given UUID forwards.
- (void)move:(NSUUID *)UUID;

// Turns the player with the given UUID.
- (void)turn:(NSUUID *)UUID;

- (NSData *)toJSON;

@end
