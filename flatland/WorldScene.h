//
//  MyScene.h
//  flatland
//

//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Serializable.h"

@interface WorldScene : SKScene <Serializable>

// Spawns a player with the given UUID.
- (void)spawn:(NSUUID *)UUID;

- (NSData *)toJSON;

@end
