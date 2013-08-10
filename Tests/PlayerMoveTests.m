//
//  MovePlayerTests.m
//  Flatland
//
//  Created by Josh Bassett on 30/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AcceptanceTestCase.h"

@interface PlayerMoveTests : AcceptanceTestCase
@end

@implementation PlayerMoveTests

- (void)testMovePlayer {
  NSUUID *playerUUID = [NSUUID UUID];

  [self runAction:@"spawn" forPlayer:playerUUID parameters:nil timeout:5];

  NSDictionary *response = [self runAction:@"move" forPlayer:playerUUID parameters:@{@"amount": @1} timeout:3];
  NSDictionary *playerState = [self playerStateForPlayer:playerUUID withResponse:response];

  expect([playerState objectForKey:@"state"]).to.equal(@"moving");
  expect([playerState objectForKey:@"energy"]).to.equal(80);
}

- (void)testMovePlayerWhenPlayerIsDead {
  NSUUID *playerUUID = [NSUUID UUID];
  NSDictionary *response = [self runAction:@"move" forPlayer:playerUUID parameters:@{@"amount": @1} timeout:3];

  expect([response objectForKey:@"code"]).to.equal(4);
  expect([response objectForKey:@"error"]).to.equal(@"Player has not spawned");
}

- (void)testMovePlayerWhenPlayerHasInsufficientEnergy {
  NSUUID *playerUUID = [NSUUID UUID];

  [self runAction:@"spawn" forPlayer:playerUUID parameters:nil timeout:5];

  [self runAction:@"move" forPlayer:playerUUID parameters:@{@"amount": @1} timeout:3];
  [self runAction:@"move" forPlayer:playerUUID parameters:@{@"amount": @1} timeout:3];
  [self runAction:@"move" forPlayer:playerUUID parameters:@{@"amount": @1} timeout:3];
  [self runAction:@"move" forPlayer:playerUUID parameters:@{@"amount": @1} timeout:3];
  [self runAction:@"move" forPlayer:playerUUID parameters:@{@"amount": @1} timeout:3];

  NSDictionary *response = [self runAction:@"move" forPlayer:playerUUID parameters:@{@"amount": @1} timeout:3];

  expect([response objectForKey:@"code"]).to.equal(6);
  expect([response objectForKey:@"error"]).to.equal(@"Player has insufficient energy");
}

@end
