//
//  PlayerSpawnActionTests.m
//  Flatland
//
//  Created by Josh Bassett on 19/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "GameError.h"
#import "OCMock.h"
#import "Player.h"
#import "PlayerSpawnAction.h"

@interface PlayerSpawnActionTests : XCTestCase
@end

@implementation PlayerSpawnActionTests {
  PlayerAction *_playerAction;
  id _player;
}

- (void)setUp {
  [super setUp];
  _player = [OCMockObject mockForClass:Player.class];
  _playerAction = [[PlayerSpawnAction alloc] initWithOptions:@{}];
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
  void (^block)(void) = ^{};
  [[_player expect] spawn:3 completion:block];
  [_playerAction applyToPlayer:_player completion:block];
}

- (void)testValidateReturnsNoErrorWhenPlayerIsDead {
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:NO]] isAlive];

  GameError *error;
  BOOL result = [_playerAction validateForPlayer:_player error:&error];

  expect(result).to.beTruthy();
  expect(error).to.beNil();
}

- (void)testValidateReturnsErrorWhenPlayerIsAlive {
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:YES]] isAlive];

  GameError *error;
  BOOL result = [_playerAction validateForPlayer:_player error:&error];

  expect(result).to.beFalsy();
  expect(error.code).to.equal(GameErrorPlayerAlreadySpawned);
}

@end
