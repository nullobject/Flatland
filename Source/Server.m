//
//  Server.m
//  Flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "PlayerSpawnAction.h"
#import "PlayerSuicideAction.h"
#import "PlayerIdleAction.h"
#import "PlayerMoveAction.h"
#import "PlayerTurnAction.h"
#import "PlayerAttackAction.h"
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

- (void)respondToPlayer:(NSUUID *)uuid withWorld:(World *)world {
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

- (RequestHandler)requestHandlerForPlayerActionClass:(Class)class {
  return ^(RouteRequest *request, RouteResponse *response) {
    GameError *error;

    NSUUID *uuid = [self parsePlayer:request error:&error];
    if (error) return [response respondWithJSON:error];

    NSDictionary *options = [self parseOptions:request error:&error];
    if (error) return [response respondWithJSON:error];

    PlayerAction *playerAction = [(PlayerAction *)[class alloc] initWithOptions:options];

    [response beginAsyncJSONResponse];
    [self enqueueResponse:response forPlayer:uuid];
    [_delegate server:self didReceiveAction:playerAction forPlayer:uuid];
  };
}

- (void)setupRoutes {
  [self put:@"/action/spawn"   withBlock:[self requestHandlerForPlayerActionClass:PlayerSpawnAction.class]];
  [self put:@"/action/suicide" withBlock:[self requestHandlerForPlayerActionClass:PlayerSuicideAction.class]];
  [self put:@"/action/idle"    withBlock:[self requestHandlerForPlayerActionClass:PlayerIdleAction.class]];
  [self put:@"/action/move"    withBlock:[self requestHandlerForPlayerActionClass:PlayerMoveAction.class]];
  [self put:@"/action/turn"    withBlock:[self requestHandlerForPlayerActionClass:PlayerTurnAction.class]];
  [self put:@"/action/attack"  withBlock:[self requestHandlerForPlayerActionClass:PlayerAttackAction.class]];
}

@end
