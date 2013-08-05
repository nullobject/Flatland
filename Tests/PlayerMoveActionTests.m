//
//  PlayerMoveActionTests.m
//  Flatland
//
//  Created by Josh Bassett on 19/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "OCMock.h"
#import "Player.h"
#import "PlayerMoveAction.h"

@interface PlayerMoveActionTests : XCTestCase
@end

@implementation PlayerMoveActionTests {
  PlayerAction *_playerAction;
  id _player;
}

- (void)setUp {
  [super setUp];
  NSDictionary *options = @{@"amount": [NSNumber numberWithFloat:0.5]};
  _player = [OCMockObject mockForClass:Player.class];
  _playerAction = [[PlayerMoveAction alloc] initWithOptions:options];
}

- (void)tearDown {
  _playerAction = nil;
  _player = nil;
  [super tearDown];
}

- (void)testCost {
  expect(_playerAction.cost).to.equal(10);
}

- (void)testApplyToPlayer {
  [(Player *)[[_player stub] andReturnValue:[NSNumber numberWithDouble:0]] rotation];
  void (^block)(void) = ^{};
  [[_player expect] moveByX:0 y:50 duration:0.25 completion:block];
  [_playerAction applyToPlayer:_player completion:block];
}

- (void)testValidateReturnsNoErrorWhenPlayerIsAlive {
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:YES]] isAlive];
  [[[_player stub] andReturnValue:[NSNumber numberWithDouble:100]] energy];

  GameError *error;
  BOOL result = [_playerAction validateForPlayer:_player error:&error];

  expect(result).to.beTruthy();
  expect(error).to.beNil();
}

- (void)testValidateReturnsErrorWhenPlayerHasInsufficientEnergy {
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:YES]] isAlive];
  [[[_player stub] andReturnValue:[NSNumber numberWithDouble:0]] energy];

  GameError *error;
  BOOL result = [_playerAction validateForPlayer:_player error:&error];

  expect(result).to.beFalsy();
  expect(error.code).to.equal(GameErrorPlayerInsufficientEnergy);
}

- (void)testValidateReturnsErrorWhenPlayerIsDead {
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:NO]] isAlive];

  GameError *error;
  BOOL result = [_playerAction validateForPlayer:_player error:&error];

  expect(result).to.beFalsy();
  expect(error.code).to.equal(GameErrorPlayerNotSpawned);
}

@end
