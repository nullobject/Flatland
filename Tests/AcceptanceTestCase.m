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

- (id)doAction:(NSString *)action forPlayer:(NSUUID *)uuid {
  return [self doAction:action forPlayer:uuid parameters:nil];
}

- (id)doAction:(NSString *)action forPlayer:(NSUUID *)uuid parameters:(NSDictionary *)parameters {
  AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kRootURL]];

  // Set JSON parameter encoding.
  httpClient.parameterEncoding = AFJSONParameterEncoding;

  // Set the X-Player header.
  [httpClient setDefaultHeader:@"X-Player" value:[uuid UUIDString]];

  NSMutableURLRequest *request = [httpClient requestWithMethod:@"PUT"
                                                          path:action
                                                    parameters:parameters];

  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                      success:nil
                                                                                      failure:nil];

  [operation start];
  [operation waitUntilFinished];

  return operation.responseJSON;
}

@end
