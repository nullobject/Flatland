//
//  PlayerTests.m
//  FlatlandTests
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "OCMock.h"
#import "Player.h"
#import "World.h"

@interface PlayerTests : XCTestCase
@end

@implementation PlayerTests {
  Player *_player;
  id _world;
}

- (void)setUp {
  [super setUp];
  _world = [OCMockObject mockForClass:World.class];
  _player = [[Player alloc] initWithUUID:[NSUUID UUID]];
  _player.world = _world;
}

- (void)tearDown {
  [_world verify];
  _world = nil;
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
  [[_world stub] playerDidSpawn:_player];

  _player.state = PlayerStateDead;
  XCTAssertThrows([_player spawn]);

  _player.state = PlayerStateSpawning;
  XCTAssertNoThrow([_player spawn]);
}

- (void)testSpawnSetsState {
  [[_world stub] playerDidSpawn:_player];
  _player.state = PlayerStateSpawning;
  [_player spawn];
  XCTAssertEquals(_player.state, PlayerStateIdle);
}

- (void)testSpawnSetsHealth {
  [[_world stub] playerDidSpawn:_player];
  _player.state = PlayerStateSpawning;
  [_player spawn];
  XCTAssertEquals(_player.health, (CGFloat)100);
}

- (void)testSpawnSetsEnergy {
  [[_world stub] playerDidSpawn:_player];
  _player.state = PlayerStateSpawning;
  [_player spawn];
  XCTAssertEquals(_player.energy, (CGFloat)100);
}

- (void)testSpawnAddsPlayerNode {
  [[_world stub] playerDidSpawn:_player];
  _player.state = PlayerStateSpawning;
  XCTAssertNil(_player.playerNode);
  [_player spawn];
  XCTAssertNotNil(_player.playerNode);
}

- (void)testDieSetsState {
  [[_world stub] playerDidDie:_player];
  _player.state = PlayerStateIdle;
  [_player die];
  XCTAssertEquals(_player.state, PlayerStateDead);
}

- (void)testDieIncrementsDeaths {
  [[_world stub] playerDidDie:_player];
  _player.state = PlayerStateIdle;
  XCTAssertEquals(_player.deaths, (NSUInteger)0);
  [_player die];
  XCTAssertEquals(_player.deaths, (NSUInteger)1);
}

- (void)testDieRemovesPlayerNode {
  [[_world stub] playerDidSpawn:_player];
  [[_world expect] playerDidDie:_player];

  _player.state = PlayerStateSpawning;
  [_player spawn];

  XCTAssertNotNil(_player.playerNode);
  [_player die];
  XCTAssertNil(_player.playerNode);
}

@end
