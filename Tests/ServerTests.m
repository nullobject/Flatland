//
//  ServerTests.m
//  Flatland
//
//  Created by Josh Bassett on 22/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "Server.h"

@interface ServerTests : XCTestCase
@end

@implementation ServerTests {
}

- (void)setUp {
  [super setUp];
  [Expecta setAsynchronousTestTimeout:5];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testExample {
  AppDelegate *delegate = [NSApplication sharedApplication].delegate;
  XCTAssertNotNil(delegate.game);

  NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"910A0975-6EA9-4EA6-A40F-7D02FAC30F4F"];

  NSURL *url = [NSURL URLWithString:@"http://localhost:8000/action/spawn"];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [request setHTTPMethod:@"PUT"];
  [request setValue:[uuid UUIDString] forHTTPHeaderField:@"X-Player"];

  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:nil failure:nil];
  [operation start];

  expect(operation.isFinished).will.beTruthy();
  expect(operation.error).will.beNil();
  expect(operation.responseJSON).willNot.beNil();
}

@end
