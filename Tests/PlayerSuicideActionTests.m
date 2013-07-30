//
//  PlayerSuicideActionTests.m
//  Flatland
//
//  Created by Josh Bassett on 19/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "GameError.h"
#import "OCMock.h"
#import "Player.h"
#import "PlayerSuicideAction.h"

@interface PlayerSuicideActionTests : XCTestCase
@end

@implementation PlayerSuicideActionTests {
  PlayerAction *_playerAction;
  id _player;
}

- (void)setUp {
  [super setUp];
  _player = [OCMockObject mockForClass:Player.class];
  _playerAction = [[PlayerSuicideAction alloc] initWithOptions:@{}];
}

- (void)tearDown {
  _playerAction = nil;
  _player = nil;
  [super tearDown];
}

- (void)testCost {
  expect(_playerAction.cost).to.equal(0);
}

- (void)testApplyToPlayer {
  [[_player expect] die];
  [_playerAction applyToPlayer:_player];
}

- (void)testValidateReturnsNoErrorWhenPlayerIsAlive {
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:YES]] isAlive];
  [[[_player stub] andReturnValue:[NSNumber numberWithDouble:100]] energy];

  GameError *error;
  BOOL result = [_playerAction validateForPlayer:_player error:&error];

  expect(result).to.beTruthy();
  expect(error).to.beNil();
}

- (void)testValidateReturnsErrorWhenPlayerIsDead {
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:NO]] isAlive];

  GameError *error;
  BOOL result = [_playerAction validateForPlayer:_player error:&error];

  expect(result).to.beFalsy();
  expect(error.code).to.equal(GameErrorPlayerNotSpawned);
}

@end
