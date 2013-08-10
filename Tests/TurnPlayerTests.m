//
//  TurnPlayerTests.m
//  Flatland
//
//  Created by Josh Bassett on 30/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AcceptanceTestCase.h"

@interface TurnPlayerTests : AcceptanceTestCase
@end

@implementation TurnPlayerTests

- (void)testTurnPlayer {
  NSUUID *playerUUID = [NSUUID UUID];

  [self runAction:@"spawn" forPlayer:playerUUID parameters:nil timeout:5];

  NSDictionary *response = [self runAction:@"turn" forPlayer:playerUUID parameters:@{@"amount": @1} timeout:3];
  NSDictionary *playerState = [self playerStateForPlayer:playerUUID withResponse:response];

  expect([playerState objectForKey:@"state"]).to.equal(@"turning");
  expect([playerState objectForKey:@"energy"]).to.equal(80);
}

- (void)testTurnPlayerWhenPlayerIsDead {
  NSUUID *playerUUID = [NSUUID UUID];
  NSDictionary *response = [self runAction:@"turn" forPlayer:playerUUID parameters:@{@"amount": @1} timeout:3];

  expect([response objectForKey:@"code"]).to.equal(4);
  expect([response objectForKey:@"error"]).to.equal(@"Player has not spawned");
}

@end
