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
  Player *_entity;
}

- (void)setUp {
  [super setUp];
  _entity = [[Player alloc] initWithUUID:[NSUUID UUID]];
}

- (void)tearDown {
  _entity = nil;
  [super tearDown];
}

- (void)testEnergyIsClamped {
  _entity.energy = -10;
  XCTAssertEquals(_entity.energy, (CGFloat)0);

  _entity.energy = 110;
  XCTAssertEquals(_entity.energy, (CGFloat)100);
}

- (void)testIdleSetsState {
  [_entity idle];
  XCTAssertEquals(_entity.state, PlayerStateIdle);
}

- (void)testMoveSetsState {
  [_entity moveBy:1];
  XCTAssertEquals(_entity.state, PlayerStateMoving);
}

- (void)testTurnSetsState {
  [_entity turnBy:1.0];
  XCTAssertEquals(_entity.state, PlayerStateTurning);
}

- (void)testAttackSetsState {
  [_entity attack];
  XCTAssertEquals(_entity.state, PlayerStateAttacking);
}

@end
