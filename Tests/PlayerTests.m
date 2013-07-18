//
//  PlayerTests.m
//  FlatlandTests
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "BulletNode.h"
#import "OCMock.h"
#import "Player.h"
#import "PlayerIdleAction.h"
#import "PlayerNode.h"
#import "World.h"

@interface Player (Test)

@property (nonatomic) PlayerNode  *playerNode;
@property (nonatomic) PlayerState state;
@property (nonatomic) CGFloat     health;
@property (nonatomic) CGFloat     energy;

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
  _player.state = PlayerStateIdle;
}

- (void)tearDown {
  [_world verify];
  _world = nil;
  _player = nil;
  [super tearDown];
}

#pragma mark - Tick

- (void)testTickIncrementsAge {
  XCTAssertEquals(_player.age, (NSUInteger)0);
  [_player tick];
  XCTAssertEquals(_player.age, (NSUInteger)1);
}

- (void)testTickDefaultsToIdleAction {
  _player.state = PlayerStateIdle;
  _player.energy = 90;
  [_player tick];
  XCTAssertEquals(_player.energy, (CGFloat)100);
}

#pragma mark - Spawn

- (void)testSpawnThrowsErrorWhenNotDead {
  _player.state = PlayerStateIdle;
  XCTAssertThrows([_player spawn]);
}

- (void)testSpawnSetsState {
  _player.state = PlayerStateDead;
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

#pragma mark - Die

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

- (void)testDieCallsPlayerDidDie {
  [[_world expect] playerDidDie:_player];
  _player.playerNode = [OCMockObject mockForClass:PlayerNode.class];
  [_player die];
  XCTAssertNil(_player.playerNode);
}

- (void)testDieThrowsErrorWhenNotAlive {
  [[_world stub] playerDidDie:_player];
  _player.state = PlayerStateDead;
  XCTAssertThrows([_player die]);
}

#pragma mark - Attack

- (void)testAttackThrowsErrorWhenNotAlive {
  _player.state = PlayerStateDead;
  XCTAssertThrows([_player attack]);
}

- (void)testAttackSetsState {
  [[_world stub] player:_player didShootBullet:[OCMArg any]];
  [_player attack];
  XCTAssertEquals(_player.state, PlayerStateAttacking);
}

- (void)testAttackCallsPlayerDidShootBullet {
  [[_world expect] player:_player
           didShootBullet:[OCMArg checkWithBlock:^BOOL(BulletNode *bullet) { return (bullet.player == _player); }]];
  [_player attack];
}

#pragma mark - Move

- (void)testMoveThrowsErrorWhenNotAlive {
  _player.state = PlayerStateDead;
  XCTAssertThrows([_player moveByX:1 y:2 duration:3]);
}

- (void)testMoveSetsState {
  [_player moveByX:1 y:2 duration:3];
  XCTAssertEquals(_player.state, PlayerStateMoving);
}

- (void)testMoveRunsActionOnPlayerNode {
  id playerNode = [OCMockObject mockForClass:PlayerNode.class];
  [[playerNode expect] runAction:[OCMArg any]];
  _player.playerNode = playerNode;
  [_player moveByX:1 y:2 duration:3];
  [playerNode verify];
}

#pragma mark - Rotate

- (void)testRotateThrowsErrorWhenNotAlive {
  _player.state = PlayerStateDead;
  XCTAssertThrows([_player rotateByAngle:1 duration:2]);
}

- (void)testRotateSetsState {
  [_player rotateByAngle:1 duration:2];
  XCTAssertEquals(_player.state, PlayerStateTurning);
}

- (void)testRotateRunsActionOnPlayerNode {
  id playerNode = [OCMockObject mockForClass:PlayerNode.class];
  [[playerNode expect] runAction:[OCMArg any]];
  _player.playerNode = playerNode;
  [_player rotateByAngle:1 duration:2];
  [playerNode verify];
}

#pragma mark - PlayerDelegate

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
