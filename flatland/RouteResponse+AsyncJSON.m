//
//  RouteResponse+AsyncJSON.m
//  flatland
//
//  Created by Josh Bassett on 25/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "HTTPAsyncDataResponse.h"
#import "HTTPConnection.h"
#import "RouteResponse+AsyncJSON.h"

NSString *kContentType = @"Content-Type";

@implementation RouteResponse (AsyncJSON)

- (void)beginAsyncJSONResponse {
  [self setHeader:kContentType value:@"application/json"];
  self.response = [[HTTPAsyncDataResponse alloc] init];;
}

- (void)endAsyncJSONResponse:(NSObject <Serializable> *)object {
  NSData *data = [self serialize:object];
  [(HTTPAsyncDataResponse *)self.response setData:data];
  [self.connection responseHasAvailableData:self.response];
}

- (void)respondWithAsyncJSON:(NSObject <Serializable> *)object {
  [self setHeader:kContentType value:@"application/json"];
  NSData *data = [self serialize:object];
  [self respondWithData:data];
}

- (NSData *)serialize:(NSObject <Serializable> *)object {
  NSError *error;
  return [NSJSONSerialization dataWithJSONObject:[object asJSON]
                                         options:NSJSONWritingPrettyPrinted
                                           error:&error];
}

@end
