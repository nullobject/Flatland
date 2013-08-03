//
//  Server.h
//  Flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GameError.h"
#import "Player.h"
#import "RoutingHTTPServer.h"
#import "World.h"

#define kDefaultPort 8000

#define kXPlayer  @"X-Player"
#define kServer   @"Server"
#define kFlatland @"Flatland/1.0"

#define kUnprocessableEntity 422

@class Server;

@protocol ServerDelegate <NSObject>

// Called when the server received an action for a player.
- (id)server:(Server *)server didReceiveAction:(PlayerAction *)action forPlayer:(NSUUID *)uuid error:(GameError **)error;

// Called when the server received an asynchronous action for a player.
- (void)server:(Server *)server didReceiveAsyncAction:(PlayerAction *)action forPlayer:(NSUUID *)uuid;

@end

@interface Server : RoutingHTTPServer

@property (nonatomic, weak) id <ServerDelegate> delegate;

// Responds to the player with the given world.
- (void)respondToPlayer:(NSUUID *)uuid withWorld:(World *)world;

// Responds to the player with the given error.
- (void)respondToPlayer:(NSUUID *)uuid withError:(GameError *)error;

@end
