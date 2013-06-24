//
//  Server.h
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RoutingHTTPServer.h"

@class Server;

@protocol ServerDelegate <NSObject>
@optional
- (NSData *)server:(Server *)server didIdlePlayer:(NSUUID *)uuid;
- (NSData *)server:(Server *)server didSpawnPlayer:(NSUUID *)uuid;
- (NSData *)server:(Server *)server didMovePlayer:(NSUUID *)uuid withOptions:(NSDictionary *)options;
- (NSData *)server:(Server *)server didTurnPlayer:(NSUUID *)uuid withOptions:(NSDictionary *)options;

@end

@interface Server : RoutingHTTPServer

@property (nonatomic, weak) id <ServerDelegate> delegate;

@end
