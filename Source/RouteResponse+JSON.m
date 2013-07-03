//
//  RouteResponse+JSON.m
//  flatland
//
//  Created by Josh Bassett on 25/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "HTTPAsyncDataResponse.h"
#import "HTTPConnection.h"
#import "RouteResponse+JSON.h"

NSString *kContentType     = @"Content-Type";
NSString *kApplicationJSON = @"application/json";

@implementation RouteResponse (JSON)

- (void)respondWithJSON:(NSObject <Serializable> *)object {
  NSData *data = [self serialize:object];
  [self setHeader:kContentType value:kApplicationJSON];
  [self respondWithData:data];
}

- (void)beginAsyncJSONResponse {
  [self setHeader:kContentType value:kApplicationJSON];
  self.response = [[HTTPAsyncDataResponse alloc] init];;
}

- (void)endAsyncJSONResponse:(NSObject <Serializable> *)object {
  NSAssert([self.response isMemberOfClass:HTTPAsyncDataResponse.class], @"No async JSON response has been started");

  NSData *data = [self serialize:object];
  HTTPAsyncDataResponse *httpAsyncDataResponse = (HTTPAsyncDataResponse *)self.response;

  [httpAsyncDataResponse setData:data];

  if (!httpAsyncDataResponse.closed) {
    [self.connection responseHasAvailableData:self.response];
  }
}

- (NSData *)serialize:(NSObject <Serializable> *)object {
  NSError *error;
  return [NSJSONSerialization dataWithJSONObject:[object asJSON]
                                         options:kNilOptions
                                           error:&error];
}

@end
