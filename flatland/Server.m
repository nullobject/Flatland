//
//  Server.m
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "RouteResponse+AsyncJSON.h"
#import "Server.h"

@implementation Server {
  NSMutableDictionary *_playerResponses;
}

- (Server *)init {
  if (self = [super init]) {
    _playerResponses = [[NSMutableDictionary alloc] init];
    [self setPort:kDefaultPort];
    [self setDefaultHeader:kServer value:kFlatland];
    [self setupRoutes];
  }

  return self;
}

- (void)respondToPlayer:(NSUUID *)uuid withWorld:(WorldScene *)world {
  RouteResponse *response = [_playerResponses objectForKey:uuid];
  [_playerResponses removeObjectForKey:uuid];
  [response endAsyncJSONResponse:world];
}

#pragma - Private

- (void)enqueueResponse:(RouteResponse *)response forPlayer:(NSUUID *)uuid {
  [_playerResponses setObject:response forKey:uuid];
}

- (void)setupRoutes {
	[self put:@"/action/idle" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    Action *action = [[SpawnAction alloc] init];

    [_delegate server:self didReceiveAction:action forPlayer:uuid];
    [response beginAsyncJSONResponse];
    [self enqueueResponse:response forPlayer:uuid];
	}];

	[self put:@"/action/spawn" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    Action *action = [[SpawnAction alloc] init];

    [_delegate server:self didReceiveAction:action forPlayer:uuid];
    [response beginAsyncJSONResponse];
    [self enqueueResponse:response forPlayer:uuid];
	}];

	[self put:@"/action/move" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    NSError *error;
    NSDictionary *options = [NSJSONSerialization JSONObjectWithData:request.body options:kNilOptions error:&error];
    CGFloat amount = [(NSNumber *)[options objectForKey:@"amount"] floatValue];
    Action *action = [[MoveAction alloc] initWithAmount:amount];

    [_delegate server:self didReceiveAction:action forPlayer:uuid];
    [response beginAsyncJSONResponse];
    [self enqueueResponse:response forPlayer:uuid];
	}];

	[self put:@"/action/turn" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    NSError *error;
    NSDictionary *options = [NSJSONSerialization JSONObjectWithData:request.body options:kNilOptions error:&error];
    CGFloat amount = [(NSNumber *)[options objectForKey:@"amount"] floatValue];
    Action *action = [[TurnAction alloc] initWithAmount:amount];

    [_delegate server:self didReceiveAction:action forPlayer:uuid];
    [response beginAsyncJSONResponse];
    [self enqueueResponse:response forPlayer:uuid];
	}];
}

@end
