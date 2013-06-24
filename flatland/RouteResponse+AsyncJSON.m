//
//  RouteResponse+AsyncJSON.m
//  flatland
//
//  Created by Josh Bassett on 25/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "RouteResponse+AsyncJSON.h"

NSString *kContentType = @"Content-Type";

@implementation RouteResponse (AsyncJSON)

- (void)respondWithAsyncJSON:(NSDictionary *)json {
  [self setHeader:kContentType value:@"application/json"];
  NSData *data = [self serialize:json];
  [self respondWithData:data];
}

- (NSData *)serialize:(NSDictionary *)json {
  NSError *error;
  return [NSJSONSerialization dataWithJSONObject:json
                                         options:NSJSONWritingPrettyPrinted
                                           error:&error];
}

@end
