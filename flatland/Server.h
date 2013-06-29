//
//  Server.h
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Action.h"
#import "RequestError.h"
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

- (void)respondToPlayer:(NSUUID *)uuid withWorld:(WorldScene *)world;
- (void)respondToPlayer:(NSUUID *)uuid withError:(RequestError *)error;

@end
