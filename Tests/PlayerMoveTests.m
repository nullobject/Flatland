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

@implementation PlayerMoveTests {
  NSUUID *_playerUUID;
}

- (void)setUp {
  [super setUp];
  _playerUUID = [NSUUID UUID];
}

- (void)tearDown {
  [self runAction:@"suicide" forPlayer:_playerUUID parameters:nil timeout:kTimeout];
  [super tearDown];
}

- (void)testMovePlayer {
  [self runAction:@"spawn" forPlayer:_playerUUID parameters:nil timeout:kTimeout];

  NSDictionary *response = [self runAction:@"move" forPlayer:_playerUUID parameters:@{@"amount": @1} timeout:kTimeout];
  NSDictionary *playerState = [self playerStateForPlayer:_playerUUID withResponse:response];

  expect([playerState objectForKey:@"state"]).to.equal(@"moving");
  expect([playerState objectForKey:@"energy"]).to.equal(80);
}

- (void)testMovePlayerWhenPlayerIsDead {
  NSDictionary *response = [self runAction:@"move" forPlayer:_playerUUID parameters:@{@"amount": @1} timeout:kTimeout];

  expect([response objectForKey:@"code"]).to.equal(4);
  expect([response objectForKey:@"error"]).to.equal(@"Player has not spawned");
}

- (void)testMovePlayerWhenPlayerHasInsufficientEnergy {
  [self runAction:@"spawn" forPlayer:_playerUUID parameters:nil timeout:kTimeout];

  [self runAction:@"move" forPlayer:_playerUUID parameters:@{@"amount": @1} timeout:kTimeout];
  [self runAction:@"move" forPlayer:_playerUUID parameters:@{@"amount": @1} timeout:kTimeout];
  [self runAction:@"move" forPlayer:_playerUUID parameters:@{@"amount": @1} timeout:kTimeout];
  [self runAction:@"move" forPlayer:_playerUUID parameters:@{@"amount": @1} timeout:kTimeout];
  [self runAction:@"move" forPlayer:_playerUUID parameters:@{@"amount": @1} timeout:kTimeout];

  NSDictionary *response = [self runAction:@"move" forPlayer:_playerUUID parameters:@{@"amount": @1} timeout:kTimeout];

  expect([response objectForKey:@"code"]).to.equal(6);
  expect([response objectForKey:@"error"]).to.equal(@"Player has insufficient energy");
}

@end
