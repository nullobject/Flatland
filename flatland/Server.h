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
- (NSData *)server:(Server *)server idlePlayerWithUUID:(NSUUID *)uuid;
- (NSData *)server:(Server *)server spawnPlayerWithUUID:(NSUUID *)uuid;
- (NSData *)server:(Server *)server forwardPlayerWithUUID:(NSUUID *)uuid;
- (NSData *)server:(Server *)server reversePlayerWithUUID:(NSUUID *)uuid;
- (NSData *)server:(Server *)server turnPlayerWithUUID:(NSUUID *)uuid;

@end

@interface Server : RoutingHTTPServer

@property (nonatomic, weak) id <ServerDelegate> delegate;

@end
