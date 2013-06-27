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

NSString *kContentType     = @"Content-Type";
NSString *kApplicationJSON = @"application/json";

@implementation RouteResponse (AsyncJSON)

- (void)beginAsyncJSONResponse {
  [self setHeader:kContentType value:kApplicationJSON];
  self.response = [[HTTPAsyncDataResponse alloc] init];;
}

- (void)endAsyncJSONResponse:(NSObject <Serializable> *)object {
  NSData *data = [self serialize:object];
  [(HTTPAsyncDataResponse *)self.response setData:data];
  [self.connection responseHasAvailableData:self.response];
}

- (NSData *)serialize:(NSObject <Serializable> *)object {
  NSError *error;
  return [NSJSONSerialization dataWithJSONObject:[object asJSON]
                                         options:kNilOptions
                                           error:&error];
}

@end
