//
//  Game.h
//  Flatland
//
//  Created by Josh Bassett on 24/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BattleScene.h"
#import "Server.h"
#import "World.h"

@interface Game : NSObject <ServerDelegate>

@property (nonatomic, readonly, strong) BattleScene *battleScene;
@property (nonatomic, readonly, strong) World *world;

// Starts the server.
- (void)startServer;

// Ticks the game state.
- (void)tick;

@end
