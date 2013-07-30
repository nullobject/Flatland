//
//  SpawnPlayerTests.m
//  Flatland
//
//  Created by Josh Bassett on 22/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "NSArray+FP.h"
#import "NSBundle+InfoDictionaryKeyPath.h"
#import "Server.h"

NSString * const kRootURL = @"http://localhost:8000";

@interface SpawnPlayerTests : XCTestCase
@end

@implementation SpawnPlayerTests {
}

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testSpawnPlayer {
  NSUUID *uuid = [NSUUID UUID];
  NSDictionary *response = [self doAction:@"/action/spawn" forPlayer:uuid];
  NSDictionary *player = [[response objectForKey:@"players"] find:^BOOL(id player, NSUInteger index, BOOL *stop) {
    return [[uuid UUIDString] isEqualToString:[player objectForKey:@"id"]];
  }];

  expect([response objectForKey:@"age"]).to.beGreaterThan(0);
  expect(player).toNot.beNil;
  expect([player objectForKey:@"state"]).to.equal(@"spawning");

  // Wait until player spawned.
  NSNumber *duration = [[NSBundle mainBundle] objectForInfoDictionaryKeyPath:@"Actions.Spawn.Duration"];
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:[duration doubleValue]]];

  response = [self doAction:@"/action/idle" forPlayer:uuid];
  player = [[response objectForKey:@"players"] find:^BOOL(id player, NSUInteger index, BOOL *stop) {
    return [[uuid UUIDString] isEqualToString:[player objectForKey:@"id"]];
  }];

  expect([response objectForKey:@"age"]).to.beGreaterThan(0);
  expect(player).toNot.beNil;
  expect([player objectForKey:@"state"]).to.equal(@"idle");
}

- (void)testSpawnPlayerWhenAlreadySpawning {
  NSUUID *uuid = [NSUUID UUID];
  [self doAction:@"/action/spawn" forPlayer:uuid];
  NSDictionary *response = [self doAction:@"/action/spawn" forPlayer:uuid];

  expect([response objectForKey:@"code"]).to.equal(5);
  expect([response objectForKey:@"error"]).to.equal(@"Player is already spawning");
}

- (void)testSpawnPlayerWhenAlreadyAlive {
  NSUUID *uuid = [NSUUID UUID];
  [self doAction:@"/action/spawn" forPlayer:uuid];

  // Wait until player spawned.
  NSNumber *duration = [[NSBundle mainBundle] objectForInfoDictionaryKeyPath:@"Actions.Spawn.Duration"];
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:[duration doubleValue]]];

  NSDictionary *response = [self doAction:@"/action/spawn" forPlayer:uuid];

  expect([response objectForKey:@"code"]).to.equal(6);
  expect([response objectForKey:@"error"]).to.equal(@"Player has already spawned");
}

#pragma mark - Private

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

@end
