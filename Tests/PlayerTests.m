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
#import "PlayerRestAction.h"
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
  _player.state = PlayerStateResting;
}

- (void)tearDown {
  [_world verify];
  _world = nil;
  _player = nil;
  [super tearDown];
}

#pragma mark - Tick

- (void)testTickIncrementsAge {
  expect(_player.age).to.equal(0);
  [_player tick];
  expect(_player.age).to.equal(1);
}

#pragma mark - Rest

- (void)testRestThrowsErrorWhenNotAlive {
  _player.state = PlayerStateDead;
  expect(^{ [_player rest:0 completion:^{}]; }).to.raiseAny();
}

- (void)testRestSetsState {
  _player.state = PlayerStateAttacking;
  [_player rest:0 completion:^{}];
  expect(_player.state).to.equal(PlayerStateResting);
}

#pragma mark - Spawn

- (void)testSpawnThrowsErrorWhenNotDead {
  _player.state = PlayerStateResting;
  expect(^{ [_player spawn:0 completion:^{}]; }).to.raiseAny();
}


#pragma mark - Suicide

- (void)testSuicideThrowsErrorWhenNotAlive {
  [[_world stub] playerDidDie:_player];
  _player.state = PlayerStateDead;
  expect(^{ [_player suicide:0 completion:^{}]; }).to.raiseAny();
}

- (void)testSuicideSetsState {
  [[_world stub] playerDidDie:_player];
  _player.state = PlayerStateResting;
  [_player suicide:0 completion:^{}];
  expect(_player.state).to.equal(PlayerStateDead);
}

- (void)testSuicideIncrementsDeaths {
  [[_world stub] playerDidDie:_player];
  expect(_player.deaths).to.equal(0);
  [_player suicide:0 completion:^{}];
  expect(_player.deaths).to.equal(1);
}

- (void)testSuicideUnsetsPlayerNode {
  [[_world stub] playerDidDie:_player];
  _player.playerNode = [OCMockObject mockForClass:PlayerNode.class];
  [_player suicide:0 completion:^{}];
  expect(_player.playerNode).to.beNil();
}

- (void)testSuicideCallsPlayerDidDie {
  [[_world expect] playerDidDie:_player];
  [_player suicide:0 completion:^{}];
}

#pragma mark - Attack

- (void)testAttackThrowsErrorWhenNotAlive {
  _player.state = PlayerStateDead;
  expect(^{ [_player attack:0 completion:^{}]; }).to.raiseAny();
}

- (void)testAttackSetsState {
  [[_world stub] player:_player didShootBullet:[OCMArg any]];
  _player.state = PlayerStateResting;
  [_player attack:0 completion:^{}];
  expect(_player.state).to.equal(PlayerStateAttacking);
}

- (void)testAttackCallsPlayerDidShootBullet {
  [[_world expect] player:_player
           didShootBullet:[OCMArg checkWithBlock:^BOOL(BulletNode *bullet) { return (bullet.player == _player); }]];
  [_player attack:0 completion:^{}];
}

#pragma mark - Move

- (void)testMoveThrowsErrorWhenNotAlive {
  _player.state = PlayerStateDead;
  expect(^{ [_player moveByX:1 y:2 duration:3 completion:^{}]; }).to.raiseAny();
}

- (void)testMoveSetsState {
  _player.state = PlayerStateResting;
  [_player moveByX:1 y:2 duration:3 completion:^{}];
  expect(_player.state).to.equal(PlayerStateMoving);
}

- (void)testMoveRunsActionOnPlayerNode {
  id playerNode = [OCMockObject mockForClass:PlayerNode.class];
  void (^block)(void) = ^{};
  [[playerNode expect] runAction:[OCMArg any] completion:block];
  _player.playerNode = playerNode;
  [_player moveByX:1 y:2 duration:3 completion:block];
  [playerNode verify];
}

#pragma mark - Rotate

- (void)testRotateThrowsErrorWhenNotAlive {
  _player.state = PlayerStateDead;
  expect(^{ [_player rotateByAngle:1 duration:2 completion:^{}]; }).to.raiseAny();
}

- (void)testRotateSetsState {
  _player.state = PlayerStateResting;
  [_player rotateByAngle:1 duration:2 completion:^{}];
  expect(_player.state).to.equal(PlayerStateTurning);
}

- (void)testRotateRunsActionOnPlayerNode {
  id playerNode = [OCMockObject mockForClass:PlayerNode.class];
  void (^block)(void) = ^{};
  [[playerNode expect] runAction:[OCMArg any] completion:block];
  _player.playerNode = playerNode;
  [_player rotateByAngle:1 duration:2 completion:block];
  [playerNode verify];
}

#pragma mark - Callbacks

- (void)testDidSpawnSetsState {
  [[_world stub] playerDidSpawn:_player];
  _player.state = PlayerStateDead;
  [_player didSpawn];
  expect(_player.state).to.equal(PlayerStateResting);
}

- (void)testDidSpawnSetsHealth {
  [[_world stub] playerDidSpawn:_player];
  _player.health = 0;
  [_player didSpawn];
  expect(_player.health).to.equal(100);
}

- (void)testDidSpawnSetsEnergy {
  [[_world stub] playerDidSpawn:_player];
  _player.energy = 0;
  [_player didSpawn];
  expect(_player.energy).to.equal(100);
}

- (void)testDidSpawnSetsPlayerNode {
  [[_world stub] playerDidSpawn:_player];
  expect(_player.playerNode).to.beNil();
  [_player didSpawn];
  expect(_player.playerNode).toNot.beNil();
}

- (void)testWasShotByPlayerAppliesDamage {
  _player.health = 100;
  Player *shooter = [[Player alloc] initWithUUID:[NSUUID UUID]];
  [_player wasShotByPlayer:shooter];
  expect(_player.health).to.equal(80);
}

- (void)testWasShotByPlayerIncrementsDeathsAndKillsIfPlayerDies {
  [[_world stub] playerDidDie:_player];

  _player.health = 10;

  Player *shooter = [[Player alloc] initWithUUID:[NSUUID UUID]];
  [_player wasShotByPlayer:shooter];

  expect(_player.deaths).to.equal(1);
  expect(shooter.kills).to.equal(1);
}

#pragma mark - Serializable

- (void)testAsJSON {
  id expected = @{@"id":              @"910A0975-6EA9-4EA6-A40F-7D02FAC30F4F",
                  @"state":           @"resting",
                  @"age":             @0,
                  @"health":          @0,
                  @"energy":          @0,
                  @"deaths":          @0,
                  @"kills":           @0,
                  @"position":        @{@"x": @0, @"y": @0},
                  @"rotation":        @0,
                  @"velocity":        @{@"x": @0, @"y": @0},
                  @"angularVelocity": @0};

  expect([_player asJSON]).to.equal(expected);
}

@end
