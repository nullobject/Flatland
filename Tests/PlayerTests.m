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

@end

@interface PlayerTests : XCTestCase
@end

@implementation PlayerTests {
  Player *_player;
  id _world;
}

- (void)setUp {
  [super setUp];

  NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"910A0975-6EA9-4EA6-A40F-7D02FAC30F4F"];

  _world = [OCMockObject mockForClass:World.class];

  _player = [[Player alloc] initWithUUID:uuid];
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
  _player.energy = 90;
  [_player tick];
  XCTAssertEquals(_player.energy, (CGFloat)100);
}

#pragma mark - Idle

- (void)testIdleThrowsErrorWhenNotAlive {
  _player.state = PlayerStateDead;
  XCTAssertThrows([_player idle]);
}

- (void)testIdleSetsState {
  _player.state = PlayerStateAttacking;
  [_player idle];
  XCTAssertEquals(_player.state, PlayerStateIdle);
}

#pragma mark - Spawn

- (void)testSpawnThrowsErrorWhenNotDead {
  XCTAssertThrows([_player spawn]);
}

- (void)testSpawnSetsState {
  _player.state = PlayerStateDead;
  [_player spawn];
  XCTAssertEquals(_player.state, PlayerStateSpawning);
}

#pragma mark - Die

- (void)testDieThrowsErrorWhenNotAlive {
  [[_world stub] playerDidDie:_player];
  _player.state = PlayerStateDead;
  XCTAssertThrows([_player die]);
}

- (void)testDieSetsState {
  [[_world stub] playerDidDie:_player];
  _player.state = PlayerStateIdle;
  [_player die];
  XCTAssertEquals(_player.state, PlayerStateDead);
}

- (void)testDieIncrementsDeaths {
  [[_world stub] playerDidDie:_player];
  XCTAssertEquals(_player.deaths, (NSUInteger)0);
  [_player die];
  XCTAssertEquals(_player.deaths, (NSUInteger)1);
}

- (void)testDieUnsetsPlayerNode {
  [[_world stub] playerDidDie:_player];
  _player.playerNode = [OCMockObject mockForClass:PlayerNode.class];
  [_player die];
  XCTAssertNil(_player.playerNode);
}

- (void)testDieCallsPlayerDidDie {
  [[_world expect] playerDidDie:_player];
  [_player die];
}

#pragma mark - Attack

- (void)testAttackThrowsErrorWhenNotAlive {
  _player.state = PlayerStateDead;
  XCTAssertThrows([_player attack]);
}

- (void)testAttackSetsState {
  [[_world stub] player:_player didShootBullet:[OCMArg any]];
  _player.state = PlayerStateIdle;
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
  _player.state = PlayerStateIdle;
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
  _player.state = PlayerStateIdle;
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

#pragma mark - Callbacks

- (void)testDidSpawnSetsState {
  [[_world stub] playerDidSpawn:_player];
  _player.state = PlayerStateSpawning;
  [_player didSpawn];
  XCTAssertEquals(_player.state, PlayerStateIdle);
}

- (void)testDidSpawnSetsHealth {
  [[_world stub] playerDidSpawn:_player];
  _player.health = 0;
  [_player didSpawn];
  XCTAssertEquals(_player.health, (CGFloat)100);
}

- (void)testDidSpawnSetsEnergy {
  [[_world stub] playerDidSpawn:_player];
  _player.energy = 0;
  [_player didSpawn];
  XCTAssertEquals(_player.energy, (CGFloat)100);
}

- (void)testDidSpawnSetsPlayerNode {
  [[_world stub] playerDidSpawn:_player];
  XCTAssertNil(_player.playerNode);
  [_player didSpawn];
  XCTAssertNotNil(_player.playerNode);
}

- (void)testWasShotByPlayerAppliesDamage {
  _player.health = 100;
  Player *shooter = [[Player alloc] initWithUUID:[NSUUID UUID]];
  [_player wasShotByPlayer:shooter];
  XCTAssertEquals(_player.health, (CGFloat)90);
}

- (void)testWasShotByPlayerIncrementsKillsIfPlayerDies {
  [[_world stub] playerDidDie:_player];

  _player.health = 10;

  Player *shooter = [[Player alloc] initWithUUID:[NSUUID UUID]];
  [_player wasShotByPlayer:shooter];

  XCTAssertEquals(shooter.kills, (NSUInteger)1);
}

#pragma mark - Serializable

- (void)testAsJSONIncludesID {
  id expected = @"910A0975-6EA9-4EA6-A40F-7D02FAC30F4F";
  XCTAssertEqualObjects([[_player asJSON] objectForKey:@"id"], expected);
}

- (void)testAsJSONIncludesState {
  id expected = @"idle";
  XCTAssertEqualObjects([[_player asJSON] objectForKey:@"state"], expected);
}

- (void)testAsJSONIncludesAge {
  id expected = [NSNumber numberWithUnsignedInteger:0];
  XCTAssertEqualObjects([[_player asJSON] objectForKey:@"age"], expected);
}

- (void)testAsJSONIncludesHealth {
  id expected = [NSNumber numberWithFloat:0];
  XCTAssertEqualObjects([[_player asJSON] objectForKey:@"health"], expected);
}

- (void)testAsJSONIncludesEnergy {
  id expected = [NSNumber numberWithFloat:0];
  XCTAssertEqualObjects([[_player asJSON] objectForKey:@"energy"], expected);
}

- (void)testAsJSONIncludesDeaths {
  id expected = [NSNumber numberWithUnsignedInteger:0];
  XCTAssertEqualObjects([[_player asJSON] objectForKey:@"deaths"], expected);
}

- (void)testAsJSONIncludesKills {
  id expected = [NSNumber numberWithUnsignedInteger:0];
  XCTAssertEqualObjects([[_player asJSON] objectForKey:@"kills"], expected);
}

- (void)testAsJSONIncludesPosition {
  id expected = @{@"x": [NSNumber numberWithFloat:0],
                  @"y": [NSNumber numberWithFloat:0]};
  XCTAssertEqualObjects([[_player asJSON] objectForKey:@"position"], expected);
}

- (void)testAsJSONIncludesRotation {
  id expected = [NSNumber numberWithFloat:0];
  XCTAssertEqualObjects([[_player asJSON] objectForKey:@"rotation"], expected);
}

- (void)testAsJSONIncludesVelocity {
  id expected = @{@"x": [NSNumber numberWithFloat:0],
                  @"y": [NSNumber numberWithFloat:0]};
  XCTAssertEqualObjects([[_player asJSON] objectForKey:@"velocity"], expected);
}

- (void)testAsJSONIncludesAngularVelocity {
  id expected = [NSNumber numberWithFloat:0];
  XCTAssertEqualObjects([[_player asJSON] objectForKey:@"angularVelocity"], expected);
}

@end
