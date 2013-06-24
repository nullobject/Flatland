//
//  Game.h
//  flatland
//
//  Created by Josh Bassett on 24/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Server.h"
#import "WorldScene.h"

@interface Game : NSObject <ServerDelegate>

@property (nonatomic, strong, readonly) Server *server;
@property (nonatomic, strong, readonly) WorldScene *world;

@end
