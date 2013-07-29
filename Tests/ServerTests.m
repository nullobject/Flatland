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

NSString * const kRootURL = @"http://localhost:8000";

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

- (id)doAction:(NSString *)action forPlayer:(NSUUID *)uuid {
  NSURL *url = [NSURL URLWithString:[kRootURL stringByAppendingString:action]];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

  [request setHTTPMethod:@"PUT"];
  [request setValue:[uuid UUIDString] forHTTPHeaderField:@"X-Player"];

  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:nil failure:nil];

  [operation start];
  [operation waitUntilFinished];

  return operation.responseJSON;
}

- (void)testSpawningADeadPlayer {
  NSUUID *uuid = [NSUUID UUID];
  id response = [self doAction:@"/action/spawn" forPlayer:uuid];
  id players = [response objectForKey:@"players"];

  expect([response objectForKey:@"age"]).to.beGreaterThan(0);
  expect([players[0] objectForKey:@"id"]).to.equal([uuid UUIDString]);
  expect([players[0] objectForKey:@"state"]).to.equal(@"spawning");
}

- (void)testSpawningASpawningPlayer {
  NSUUID *uuid = [NSUUID UUID];
  [self doAction:@"/action/spawn" forPlayer:uuid];
  id response = [self doAction:@"/action/spawn" forPlayer:uuid];

  expect([response objectForKey:@"code"]).to.equal(5);
  expect([response objectForKey:@"error"]).to.equal(@"Player is already spawning");
}

@end
