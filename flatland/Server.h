//
//  Server.h
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RoutingHTTPServer.h"
#import "Serializable.h"

@class Server;

@protocol ServerDelegate <NSObject>

- (NSObject <Serializable> *)server:(Server *)server didIdlePlayer:(NSUUID *)uuid;
- (NSObject <Serializable> *)server:(Server *)server didSpawnPlayer:(NSUUID *)uuid;
- (NSObject <Serializable> *)server:(Server *)server didMovePlayer:(NSUUID *)uuid withOptions:(NSDictionary *)options;
- (NSObject <Serializable> *)server:(Server *)server didTurnPlayer:(NSUUID *)uuid withOptions:(NSDictionary *)options;

@end

@interface Server : RoutingHTTPServer

@property (nonatomic, weak) id <ServerDelegate> delegate;

- (void)update;

@end
