//
//  Server.m
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "RouteResponse+AsyncJSON.h"
#import "Server.h"

NSString *kXPlayer = @"X-Player";
NSString *kServer  = @"Server";

@implementation Server

- (Server *)init {
  if (self = [super init]) {
    [self setPort:8000];
    [self setDefaultHeader:kServer value:@"Flatland/1.0"];
    [self setupRoutes];
  }

  return self;
}

// TODO: Store the response in a queue and complete them for every game tick.
// The responses should be completed with a world view for the player.
- (void)setupRoutes {
	[self put:@"/idle" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    NSDictionary *json = [_delegate server:self didIdlePlayer:uuid];
    [response respondWithAsyncJSON:json];
	}];

	[self put:@"/spawn" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    NSDictionary *json = [_delegate server:self didSpawnPlayer:uuid];
    [response respondWithAsyncJSON:json];
	}];

	[self put:@"/move" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    NSError *error;
    NSDictionary *options = [NSJSONSerialization JSONObjectWithData:request.body options:kNilOptions error:&error];
    NSDictionary *json = [_delegate server:self didMovePlayer:uuid withOptions:options];
    [response respondWithAsyncJSON:json];
	}];

	[self put:@"/turn" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    NSError *error;
    NSDictionary *options = [NSJSONSerialization JSONObjectWithData:request.body options:kNilOptions error:&error];
    NSDictionary *json = [_delegate server:self didTurnPlayer:uuid withOptions:options];
    [response respondWithAsyncJSON:json];
	}];
}

@end
