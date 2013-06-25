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

@implementation Server {
  NSMutableDictionary *_playerResponses;
}

- (Server *)init {
  if (self = [super init]) {
    _playerResponses = [[NSMutableDictionary alloc] init];
    [self setPort:8000];
    [self setDefaultHeader:kServer value:@"Flatland/1.0"];
    [self setupRoutes];
  }

  return self;
}

- (void)update {
  [_playerResponses enumerateKeysAndObjectsUsingBlock:^(NSUUID *uuid, RouteResponse *response, BOOL *stop) {
    // TODO: Run the correct action.
    [response endAsyncJSONResponse:[_delegate server:self didSpawnPlayer:uuid]];
  }];
  [_playerResponses removeAllObjects];
}

// TODO: Store the response in a queue and complete them for every game tick.
// The responses should be completed with a world view for the player.
- (void)setupRoutes {
	[self put:@"/idle" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    [response respondWithAsyncJSON:[_delegate server:self didIdlePlayer:uuid]];
	}];

	[self put:@"/spawn" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    [response beginAsyncJSONResponse];
    [_playerResponses setObject:response forKey:uuid];
//    [response respondWithAsyncJSON:[_delegate server:self didSpawnPlayer:uuid]];
	}];

	[self put:@"/move" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    NSError *error;
    NSDictionary *options = [NSJSONSerialization JSONObjectWithData:request.body options:kNilOptions error:&error];
    [response respondWithAsyncJSON:[_delegate server:self didMovePlayer:uuid withOptions:options]];
	}];

	[self put:@"/turn" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    NSError *error;
    NSDictionary *options = [NSJSONSerialization JSONObjectWithData:request.body options:kNilOptions error:&error];
    [response respondWithAsyncJSON:[_delegate server:self didTurnPlayer:uuid withOptions:options]];
	}];
}

@end
