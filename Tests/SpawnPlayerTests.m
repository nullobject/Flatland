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

  [self performAsyncTestWithBlock:^(BOOL *stop) {
    [self doAction:@"spawn" forPlayer:uuid parameters:nil completion:^(NSDictionary *response) {
      NSDictionary *player = [[response objectForKey:@"players"] find:^BOOL(id player, NSUInteger index, BOOL *stop) {
        return [[uuid UUIDString] isEqualToString:[player objectForKey:@"id"]];
      }];

      expect([player objectForKey:@"state"]).to.equal(@"resting");

      *stop = YES;
    }];
  } timeout:5];
}

- (void)testSpawnPlayerWhenPlayerIsAlive {
  NSUUID *uuid = [NSUUID UUID];

  [self performAsyncTestWithBlock:^(BOOL *stop) {
    [self doAction:@"spawn" forPlayer:uuid parameters:nil completion:^(NSDictionary *response) {
      [self doAction:@"spawn" forPlayer:uuid parameters:nil completion:^(NSDictionary *response) {
        expect([response objectForKey:@"code"]).to.equal(5);
        expect([response objectForKey:@"error"]).to.equal(@"Player has already spawned");
      }];

      *stop = YES;
    }];
  } timeout:5];
}

@end
