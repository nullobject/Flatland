//
//  PlayerTests.m
//  FlatlandTests
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Player.h"

@interface PlayerTests : XCTestCase
@end

@implementation PlayerTests {
  Player *_player;
}

- (void)setUp {
  [super setUp];
  _player = [[Player alloc] initWithUUID:[NSUUID UUID]];
}

- (void)tearDown {
  _player = nil;
  [super tearDown];
}

- (void)testHealthIsClamped {
  _player.health = -10;
  XCTAssertEquals(_player.health, (CGFloat)0);

  _player.health = 110;
  XCTAssertEquals(_player.health, (CGFloat)100);
}

- (void)testEnergyIsClamped {
  _player.energy = -10;
  XCTAssertEquals(_player.energy, (CGFloat)0);

  _player.energy = 110;
  XCTAssertEquals(_player.energy, (CGFloat)100);
}

- (void)testTickIncrementsAge {
  XCTAssertEquals(_player.age, (NSUInteger)0);
  [_player tick];
  XCTAssertEquals(_player.age, (NSUInteger)1);
}

- (void)testSpawnThrowsErrorWhenNotSpawning {
  _player.state = PlayerStateDead;
  XCTAssertThrows([_player spawn]);

  _player.state = PlayerStateSpawning;
  XCTAssertNoThrow([_player spawn]);
}

- (void)testSpawnSetsState {
  _player.state = PlayerStateSpawning;
  [_player spawn];
  XCTAssertEquals(_player.state, PlayerStateIdle);
}

- (void)testSpawnAddsPlayerNode {
  _player.state = PlayerStateSpawning;
  XCTAssertNil(_player.playerNode);
  [_player spawn];
  XCTAssertNotNil(_player.playerNode);
}

- (void)testDieSetsState {
  _player.state = PlayerStateIdle;
  [_player die];
  XCTAssertEquals(_player.state, PlayerStateDead);
}

- (void)testDieIncrementsDeaths {
  XCTAssertEquals(_player.deaths, (NSUInteger)0);
  [_player die];
  XCTAssertEquals(_player.deaths, (NSUInteger)1);
}

- (void)testDieRemovesPlayerNode {
  _player.state = PlayerStateSpawning;
  [_player spawn];
  XCTAssertNotNil(_player.playerNode);
  [_player die];
  XCTAssertNil(_player.playerNode);
}

@end
