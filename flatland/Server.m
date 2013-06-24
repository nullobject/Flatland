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
	[self put:@"/idle" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    NSData *data = [_delegate server:self didIdlePlayer:uuid];

    [response setHeader:kContentType value:@"application/json"];
    [response respondWithData:data];
	}];

	[self put:@"/spawn" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    NSData *data = [_delegate server:self didSpawnPlayer:uuid];

    [response setHeader:kContentType value:@"application/json"];
    [response respondWithData:data];
	}];

	[self put:@"/move" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    NSError *error;
    NSDictionary *options = [NSJSONSerialization JSONObjectWithData:request.body options:kNilOptions error:&error];
    NSData *data = [_delegate server:self didMovePlayer:uuid withOptions:options];

    [response setHeader:kContentType value:@"application/json"];
    [response respondWithData:data];
	}];

	[self put:@"/turn" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    NSError *error;
    NSDictionary *options = [NSJSONSerialization JSONObjectWithData:request.body options:kNilOptions error:&error];
    NSData *data = [_delegate server:self didTurnPlayer:uuid withOptions:options];

    [response setHeader:kContentType value:@"application/json"];
    [response respondWithData:data];
	}];
}

@end
