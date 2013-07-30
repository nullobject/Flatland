//
//  MovePlayerTests.m
//  Flatland
//
//  Created by Josh Bassett on 30/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AcceptanceTestCase.h"
#import "NSArray+FP.h"
#import "NSBundle+InfoDictionaryKeyPath.h"

@interface MovePlayerTests : AcceptanceTestCase
@end

@implementation MovePlayerTests

- (void)testMovePlayer {
  NSUUID *uuid = [NSUUID UUID];
  [self doAction:@"/action/spawn" forPlayer:uuid];

  // Wait until player spawned.
  NSTimeInterval duration = [[[NSBundle mainBundle] objectForInfoDictionaryKeyPath:@"Actions.Spawn.Duration"] doubleValue];
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:(duration + duration * 0.1)]];

  NSDictionary *response = [self doAction:@"/action/move" forPlayer:uuid parameters:@{@"amount": @1}];
  NSDictionary *player = [[response objectForKey:@"players"] find:^BOOL(id player, NSUInteger index, BOOL *stop) {
    return [[uuid UUIDString] isEqualToString:[player objectForKey:@"id"]];
  }];

  expect([response objectForKey:@"age"]).to.beGreaterThan(0);
  expect([player objectForKey:@"state"]).to.equal(@"moving");
  expect([player objectForKey:@"energy"]).to.equal(80);

  // Wait until player moved.
  duration = [[[NSBundle mainBundle] objectForInfoDictionaryKeyPath:@"Actions.Move.Duration"] doubleValue];
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:(duration + duration * 0.1)]];

  response = [self doAction:@"/action/idle" forPlayer:uuid];
  player = [[response objectForKey:@"players"] find:^BOOL(id player, NSUInteger index, BOOL *stop) {
    return [[uuid UUIDString] isEqualToString:[player objectForKey:@"id"]];
  }];

  expect([response objectForKey:@"age"]).to.beGreaterThan(0);
  expect([player objectForKey:@"state"]).to.equal(@"idle");
}

@end
