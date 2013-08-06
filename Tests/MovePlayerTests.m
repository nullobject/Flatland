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

@interface MovePlayerTests : AcceptanceTestCase
@end

@implementation MovePlayerTests

- (void)testMovePlayer {
  NSUUID *uuid = [NSUUID UUID];

  [self performAsyncTestWithBlock:^(BOOL *stop) {
    [self doAction:@"spawn" forPlayer:uuid parameters:nil completion:^(NSDictionary *response) {
      [self doAction:@"move" forPlayer:uuid parameters:@{@"amount": @1} completion:^(NSDictionary *response) {
        NSDictionary *player = [[response objectForKey:@"players"] find:^BOOL(id player, NSUInteger index, BOOL *stop) {
          return [[uuid UUIDString] isEqualToString:[player objectForKey:@"id"]];
        }];

        expect([player objectForKey:@"state"]).to.equal(@"moving");
        expect([player objectForKey:@"energy"]).to.equal(80);

        *stop = YES;
      }];
    }];
  } timeout:5];
}

- (void)testMovePlayerWhenPlayerIsDead {
  NSUUID *uuid = [NSUUID UUID];

  [self performAsyncTestWithBlock:^(BOOL *stop) {
    [self doAction:@"move" forPlayer:uuid parameters:@{@"amount": @1} completion:^(NSDictionary *response) {
      expect([response objectForKey:@"code"]).to.equal(4);
      expect([response objectForKey:@"error"]).to.equal(@"Player has not spawned");

      *stop = YES;
    }];
  } timeout:5];
}

@end
