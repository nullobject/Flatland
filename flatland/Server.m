//
//  Server.m
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Server.h"

NSString *kXPlayer     = @"X-Player";
NSString *kContentType = @"Content-Type";
NSString *kServer      = @"Server";

@implementation Server

- (Server *)init {
  if (self = [super init]) {
    [self setPort:8000];
    [self setDefaultHeader:kServer value:@"Flatland/1.0"];
    [self addRoutes];
  }

  return self;
}

- (void)addRoutes {
	[self get:@"/idle" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSData *data = nil;
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];

    if ([_delegate respondsToSelector:@selector(server:idlePlayerWithUUID:)]) {
      data = [_delegate server:self idlePlayerWithUUID:uuid];
    }

    [response setHeader:kContentType value:@"application/json"];
    [response respondWithData:data];
	}];

	[self get:@"/spawn" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSData *data = nil;
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];

    if ([_delegate respondsToSelector:@selector(server:spawnPlayerWithUUID:)]) {
      data = [_delegate server:self spawnPlayerWithUUID:uuid];
    }

    [response setHeader:kContentType value:@"application/json"];
    [response respondWithData:data];
	}];

	[self get:@"/move" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSData *data = nil;
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];

    if ([_delegate respondsToSelector:@selector(server:movePlayerWithUUID:)]) {
      data = [_delegate server:self movePlayerWithUUID:uuid];
    }

    [response setHeader:kContentType value:@"application/json"];
    [response respondWithData:data];
	}];

	[self get:@"/turn" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSData *data = nil;
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];

    if ([_delegate respondsToSelector:@selector(server:turnPlayerWithUUID:)]) {
      data = [_delegate server:self turnPlayerWithUUID:uuid];
    }

    [response setHeader:kContentType value:@"application/json"];
    [response respondWithData:data];
	}];
}

@end
