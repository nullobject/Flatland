//
//  Server.m
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "RouteResponse+JSON.h"
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

- (void)respondToPlayer:(NSUUID *)uuid withError:(RequestError *)error {
  RouteResponse *response = [_playerResponses objectForKey:uuid];
  response.statusCode = kUnprocessableEntity;
  [_playerResponses removeObjectForKey:uuid];
  [response endAsyncJSONResponse:error];
}

#pragma - Private

- (void)enqueueResponse:(RouteResponse *)response forPlayer:(NSUUID *)uuid {
  [_playerResponses setObject:response forKey:uuid];
}

- (NSUUID *)parsePlayer:(RouteRequest *)request error:(RequestError **)error {
  NSString *header = [request header:kXPlayer];
  
  if (!header) {
    *error = [RequestError errorWithDomain:RequestErrorDomain
                                      code:RequestErrorPlayerUUIDMissing
                                  userInfo:nil];
    return nil;
  }

  NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:header];
  
  if (!uuid) {
    *error = [RequestError errorWithDomain:RequestErrorDomain
                                      code:RequestErrorPlayerUUIDInvalid
                                  userInfo:nil];
    return nil;
  }

  return uuid;
}

- (NSDictionary *)parseOptions:(RouteRequest *)request error:(RequestError **)error {
  NSError *jsonError;
  id options = [NSJSONSerialization JSONObjectWithData:request.body
                                               options:kNilOptions
                                                 error:&jsonError];
  
  if (jsonError) {
    *error = [RequestError errorWithDomain:RequestErrorDomain
                                      code:RequestErrorJSONMalformed
                                  userInfo:@{NSUnderlyingErrorKey: jsonError}];
    return nil;
  }

  if (![options isKindOfClass:NSDictionary.class]) {
    *error = [RequestError errorWithDomain:RequestErrorDomain
                                      code:RequestErrorOptionsInvalid
                                  userInfo:nil];
    return nil;
  }


  return options;
}

- (void)setupRoutes {
	[self put:@"/action/idle" withBlock:^(RouteRequest *request, RouteResponse *response) {
    RequestError *error;

    NSUUID *uuid = [self parsePlayer:request error:&error];
    if (error) return [response respondWithJSON:error];

    Action *action = [[SpawnAction alloc] init];

    [response beginAsyncJSONResponse];
    [self enqueueResponse:response forPlayer:uuid];
    [_delegate server:self didReceiveAction:action forPlayer:uuid];
	}];

	[self put:@"/action/spawn" withBlock:^(RouteRequest *request, RouteResponse *response) {
    RequestError *error;

    NSUUID *uuid = [self parsePlayer:request error:&error];
    if (error) return [response respondWithJSON:error];

    Action *action = [[SpawnAction alloc] init];

    [response beginAsyncJSONResponse];
    [self enqueueResponse:response forPlayer:uuid];
    [_delegate server:self didReceiveAction:action forPlayer:uuid];
	}];

	[self put:@"/action/move" withBlock:^(RouteRequest *request, RouteResponse *response) {
    RequestError *error;

    NSUUID *uuid = [self parsePlayer:request error:&error];
    if (error) return [response respondWithJSON:error];

    NSDictionary *options = [self parseOptions:request error:&error];
    if (error) return [response respondWithJSON:error];

    CGFloat amount = [(NSNumber *)[options objectForKey:@"amount"] floatValue];
    Action *action = [[MoveAction alloc] initWithAmount:amount];

    [response beginAsyncJSONResponse];
    [self enqueueResponse:response forPlayer:uuid];
    [_delegate server:self didReceiveAction:action forPlayer:uuid];
	}];

	[self put:@"/action/turn" withBlock:^(RouteRequest *request, RouteResponse *response) {
    RequestError *error;

    NSUUID *uuid = [self parsePlayer:request error:&error];
    if (error) return [response respondWithJSON:error];

    NSDictionary *options = [self parseOptions:request error:&error];
    if (error) return [response respondWithJSON:error];

    CGFloat amount = [(NSNumber *)[options objectForKey:@"amount"] floatValue];
    Action *action = [[TurnAction alloc] initWithAmount:amount];

    [response beginAsyncJSONResponse];
    [self enqueueResponse:response forPlayer:uuid];
    [_delegate server:self didReceiveAction:action forPlayer:uuid];
	}];
}

@end
