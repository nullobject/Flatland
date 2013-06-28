//
//  MyScene.h
//  flatland
//

//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Action.h"
#import "Player.h"
#import "Serializable.h"

@interface WorldScene : SKScene <PlayerDelegate, Serializable>

// The age of the world in simulation iterations.
@property (nonatomic, assign) NSUInteger age;

// Runs the action for the player with the given UUID.
- (void)runAction:(Action *)action forPlayer:(NSUUID *)uuid;

@end
