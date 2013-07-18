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

@interface Player (Test)

@property (nonatomic) PlayerState state;
@property (nonatomic) CGFloat health;
@property (nonatomic) CGFloat energy;

- (void)didSpawn;

@end

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

- (void)testTickIncrementsAge {
  XCTAssertEquals(_player.age, (NSUInteger)0);
  [_player tick];
  XCTAssertEquals(_player.age, (NSUInteger)1);
}

- (void)testSpawnThrowsErrorWhenNotDead {
  _player.state = PlayerStateIdle;
  XCTAssertThrows([_player spawn]);
}

- (void)testSpawnSetsState {
  [_player spawn];
  XCTAssertEquals(_player.state, PlayerStateSpawning);
}

- (void)testDidSpawnSetsState {
  [[_world stub] playerDidSpawn:_player];
  [_player didSpawn];
  XCTAssertEquals(_player.state, PlayerStateIdle);
}

- (void)testDidSpawnSetsHealth {
  [[_world stub] playerDidSpawn:_player];
  [_player didSpawn];
  XCTAssertEquals(_player.health, (CGFloat)100);
}

- (void)testDidSpawnSetsEnergy {
  [[_world stub] playerDidSpawn:_player];
  [_player didSpawn];
  XCTAssertEquals(_player.energy, (CGFloat)100);
}

- (void)testDidSpawnAddsPlayerNode {
  [[_world stub] playerDidSpawn:_player];
  XCTAssertNil(_player.playerNode);
  [_player didSpawn];
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

  [_player didSpawn];

  XCTAssertNotNil(_player.playerNode);
  [_player die];
  XCTAssertNil(_player.playerNode);
}

- (void)testDieThrowsErrorWhenNotAlive {
  [[_world stub] playerDidDie:_player];
  _player.state = PlayerStateDead;
  XCTAssertThrows([_player die]);
}

- (void)testWasShotByPlayerDecrementsHealth {
  _player.health = 100;
  Player *shooter = [[Player alloc] initWithUUID:[NSUUID UUID]];
  [_player wasShotByPlayer:shooter];
  XCTAssertEquals(_player.health, (CGFloat)90);
}

- (void)testWasShotByPlayerIncrementsKills {
  [[_world expect] playerDidDie:_player];

  _player.state = PlayerStateIdle;
  _player.health = 10;

  Player *shooter = [[Player alloc] initWithUUID:[NSUUID UUID]];
  [_player wasShotByPlayer:shooter];

  XCTAssertEquals(shooter.kills, (NSUInteger)1);
}

@end
