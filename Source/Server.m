//
//  Server.m
//  Flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "PlayerAttackAction.h"
#import "PlayerRestAction.h"
#import "PlayerMoveAction.h"
#import "PlayerNoopAction.h"
#import "PlayerSpawnAction.h"
#import "PlayerSuicideAction.h"
#import "PlayerTurnAction.h"
#import "RouteResponse+JSON.h"
#import "Server.h"

@implementation Server {
  NSMutableDictionary *_playerResponses;
}

- (Server *)init {
  if (self = [super init]) {
    _playerResponses = [NSMutableDictionary new];
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

- (RequestHandler)requestHandlerForAction:(Class)class {
  return ^(RouteRequest *request, RouteResponse *response) {
    GameError *error;

    NSUUID *uuid = [self parsePlayer:request error:&error];
    if (error) return [response respondWithJSON:error];

    NSDictionary *options = [self parseOptions:request error:&error];
    if (error) return [response respondWithJSON:error];

    PlayerAction *playerAction = [(PlayerAction *)[class alloc] initWithOptions:options];

    [self enqueueResponse:response forPlayer:uuid];
    [response beginAsyncJSONResponse];
    [_delegate server:self didReceiveAction:playerAction forPlayer:uuid];
  };
}

- (void)setupRoutes {
  [self get:@"/player"         withBlock:[self requestHandlerForAction:PlayerNoopAction.class   ]];
  [self put:@"/player/spawn"   withBlock:[self requestHandlerForAction:PlayerSpawnAction.class  ]];
  [self put:@"/player/suicide" withBlock:[self requestHandlerForAction:PlayerSuicideAction.class]];
  [self put:@"/player/rest"    withBlock:[self requestHandlerForAction:PlayerRestAction.class   ]];
  [self put:@"/player/move"    withBlock:[self requestHandlerForAction:PlayerMoveAction.class   ]];
  [self put:@"/player/turn"    withBlock:[self requestHandlerForAction:PlayerTurnAction.class   ]];
  [self put:@"/player/attack"  withBlock:[self requestHandlerForAction:PlayerAttackAction.class ]];
}

@end
