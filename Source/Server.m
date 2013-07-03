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

- (void)respondToPlayer:(NSUUID *)uuid withError:(GameError *)error {
  RouteResponse *response = [_playerResponses objectForKey:uuid];
  response.statusCode = kUnprocessableEntity;
  [_playerResponses removeObjectForKey:uuid];
  [response endAsyncJSONResponse:error];
}

#pragma - Private

- (void)enqueueResponse:(RouteResponse *)response forPlayer:(NSUUID *)uuid {
  [_playerResponses setObject:response forKey:uuid];
}

- (NSUUID *)parsePlayer:(RouteRequest *)request error:(GameError **)error {
  NSString *header = [request header:kXPlayer];
  
  if (!header) {
    *error = [GameError errorWithDomain:GameErrorDomain
                                   code:GameErrorPlayerUUIDMissing
                               userInfo:nil];
    return nil;
  }

  NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:header];
  
  if (!uuid) {
    *error = [GameError errorWithDomain:GameErrorDomain
                                   code:GameErrorPlayerUUIDInvalid
                               userInfo:nil];
    return nil;
  }

  return uuid;
}

- (NSDictionary *)parseOptions:(RouteRequest *)request error:(GameError **)error {
  NSError *jsonError;
  if (request.body.length == 0)
    return @{};

  id options = [NSJSONSerialization JSONObjectWithData:request.body
                                               options:kNilOptions
                                                 error:&jsonError];
  
  if (jsonError) {
    *error = [GameError errorWithDomain:GameErrorDomain
                                   code:GameErrorJSONMalformed
                               userInfo:@{NSUnderlyingErrorKey: jsonError}];
    return nil;
  }

  if (![options isKindOfClass:NSDictionary.class]) {
    *error = [GameError errorWithDomain:GameErrorDomain
                                   code:GameErrorOptionsInvalid
                               userInfo:nil];
    return nil;
  }


  return options;
}

- (RequestHandler)requestHandlerForPlayerActionType:(PlayerActionType)playerActionType {
  return ^(RouteRequest *request, RouteResponse *response) {
    GameError *error;

    NSUUID *uuid = [self parsePlayer:request error:&error];
    if (error) return [response respondWithJSON:error];

    NSDictionary *options = [self parseOptions:request error:&error];
    if (error) return [response respondWithJSON:error];

    PlayerAction *action = [PlayerAction playerActionWithType:playerActionType andOptions:options];

    [response beginAsyncJSONResponse];
    [self enqueueResponse:response forPlayer:uuid];
    [_delegate server:self didReceiveAction:action forPlayer:uuid];
  };
}

- (void)setupRoutes {
  [self put:@"/action/spawn"   withBlock:[self requestHandlerForPlayerActionType:PlayerActionTypeSpawn]];
  [self put:@"/action/suicide" withBlock:[self requestHandlerForPlayerActionType:PlayerActionTypeSuicide]];
  [self put:@"/action/idle"    withBlock:[self requestHandlerForPlayerActionType:PlayerActionTypeIdle]];
  [self put:@"/action/move"    withBlock:[self requestHandlerForPlayerActionType:PlayerActionTypeMove]];
  [self put:@"/action/turn"    withBlock:[self requestHandlerForPlayerActionType:PlayerActionTypeTurn]];
}

@end
