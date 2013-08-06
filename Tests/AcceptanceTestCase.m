//
//  AcceptanceTestCase.m
//  Flatland
//
//  Created by Josh Bassett on 30/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "AcceptanceTestCase.h"
#import "AFNetworking.h"

NSString * const kRootURL = @"http://localhost:8000";

@implementation AcceptanceTestCase

- (void)doAction:(NSString *)action forPlayer:(NSUUID *)uuid parameters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *response))block {
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

- (void)performAsyncTestWithBlock:(void (^)(BOOL *stop))block timeout:(NSTimeInterval)timeout {
  NSTimeInterval timeoutSeconds = [[NSDate dateWithTimeIntervalSinceNow:timeout] timeIntervalSinceReferenceDate];
  __block BOOL stop = NO;

  block(&stop);

  while (!stop) {
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    if ([NSDate timeIntervalSinceReferenceDate] >= timeoutSeconds) {
      XCTFail(@"Timeout");
      stop = YES;
		}
  }
}

@end
