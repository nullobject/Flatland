//
//  SpawnPlayerTests.m
//  Flatland
//
//  Created by Josh Bassett on 22/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AcceptanceTestCase.h"
#import "NSArray+FP.h"

@interface SpawnPlayerTests : AcceptanceTestCase
@end

@implementation SpawnPlayerTests

- (void)testSpawnPlayer {
  NSUUID *uuid = [NSUUID UUID];
  NSDictionary *response = [self doAction:@"spawn" forPlayer:uuid];
  NSDictionary *player = [[response objectForKey:@"players"] find:^BOOL(id player, NSUInteger index, BOOL *stop) {
    return [[uuid UUIDString] isEqualToString:[player objectForKey:@"id"]];
  }];

  expect([player objectForKey:@"state"]).to.equal(@"spawning");

  [self waitForAction:@"spawn"];

  response = [self getPlayer:uuid];
  player = [[response objectForKey:@"players"] find:^BOOL(id player, NSUInteger index, BOOL *stop) {
    return [[uuid UUIDString] isEqualToString:[player objectForKey:@"id"]];
  }];

  expect([player objectForKey:@"state"]).to.equal(@"idle");
}

- (void)testSpawnPlayerWhenPlayerIsSpawning {
  NSUUID *uuid = [NSUUID UUID];
  [self doAction:@"spawn" forPlayer:uuid];
  NSDictionary *response = [self doAction:@"spawn" forPlayer:uuid];

  expect([response objectForKey:@"code"]).to.equal(5);
  expect([response objectForKey:@"error"]).to.equal(@"Player is already spawning");
}

- (void)testSpawnPlayerWhenPlayerIsAlive {
  NSUUID *uuid = [NSUUID UUID];

  [self doAction:@"spawn" forPlayer:uuid];
  [self waitForAction:@"spawn"];

  NSDictionary *response = [self doAction:@"spawn" forPlayer:uuid];

  expect([response objectForKey:@"code"]).to.equal(6);
  expect([response objectForKey:@"error"]).to.equal(@"Player has already spawned");
}

@end
