//
//  Server.h
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Action.h"
#import "GameError.h"
#import "RoutingHTTPServer.h"
#import "WorldScene.h"

#define kDefaultPort 8000

#define kXPlayer  @"X-Player"
#define kServer   @"Server"
#define kFlatland @"Flatland/1.0"

#define kUnprocessableEntity 422

@class Server;

@protocol ServerDelegate <NSObject>

- (void)server:(Server *)server didReceiveAction:(Action *)action forPlayer:(NSUUID *)uuid ;

@end

@interface Server : RoutingHTTPServer

@property (nonatomic, weak) id <ServerDelegate> delegate;

// Responds to the player with the given world.
- (void)respondToPlayer:(NSUUID *)uuid withWorld:(WorldScene *)world;

// Responds to the player with the given error.
- (void)respondToPlayer:(NSUUID *)uuid withError:(GameError *)error;

@end
