//
//  AcceptanceTestCase.m
//  Flatland
//
//  Created by Josh Bassett on 30/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "AcceptanceTestCase.h"
#import "AFNetworking.h"
#import "NSArray+FP.h"

NSString * const kRootURL = @"http://localhost:8000";

@implementation AcceptanceTestCase

- (void)runAsynchronousAction:(NSString *)action
       forPlayer:(NSUUID *)uuid
      parameters:(NSDictionary *)parameters
      completion:(void (^)(id JSON))block {
  NSURL *url = [NSURL URLWithString:kRootURL];
  NSString *path = [NSString stringWithFormat:@"/player/%@", action];
  AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];

  // Set JSON parameter encoding.
  httpClient.parameterEncoding = AFJSONParameterEncoding;

  // Set the X-Player header.
  [httpClient setDefaultHeader:@"X-Player" value:[uuid UUIDString]];

  NSMutableURLRequest *request = [httpClient requestWithMethod:@"PUT" path:path parameters:parameters];

  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    block(JSON);
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    block(JSON);
  }];

  [operation start];
}

- (NSDictionary *)runAction:(NSString *)action
                     forPlayer:(NSUUID *)uuid
                    parameters:(NSDictionary *)parameters
                       timeout:(NSTimeInterval)timeout {
  NSTimeInterval timeoutSeconds = [[NSDate dateWithTimeIntervalSinceNow:timeout] timeIntervalSinceReferenceDate];
  __block NSDictionary *response;
  __block BOOL stop = NO;

  [self runAsynchronousAction:action forPlayer:uuid parameters:parameters completion:^(id JSON) {
    response = JSON;
    stop = YES;
  }];

  while (!stop) {
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    if ([NSDate timeIntervalSinceReferenceDate] >= timeoutSeconds) {
      XCTFail(@"Timeout");
      stop = YES;
		}
  }

  return response;
}

- (NSDictionary *)playerStateForPlayer:(NSUUID *)playerUUID withResponse:(NSDictionary *)response {
  return [[response objectForKey:@"players"] find:^BOOL(id player, NSUInteger index, BOOL *stop) {
    return [[playerUUID UUIDString] isEqualToString:[player objectForKey:@"id"]];
  }];
}

@end
