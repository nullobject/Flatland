//
//  HTTPAsyncDataResponse.m
//  flatland
//
//  Created by Josh Bassett on 25/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "HTTPAsyncDataResponse.h"

@implementation HTTPAsyncDataResponse

- (void)setData:(NSData *)_data {
  data = _data;
}

- (NSData *)readDataOfLength:(NSUInteger)length {
  if (data)
    return [super readDataOfLength:length];
  else
    return nil;
}

- (BOOL)isDone {
  if (data)
    return [super isDone];
  else
    return NO;
}

- (BOOL)isChunked {
  return YES;
}

@end
