//
//  PlayerTurnActionTests.m
//  Flatland
//
//  Created by Josh Bassett on 19/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Core.h"
#import "OCMock.h"
#import "Player.h"
#import "PlayerTurnAction.h"

@interface PlayerTurnActionTests : XCTestCase
@end

@implementation PlayerTurnActionTests {
  PlayerAction *_playerAction;
  id _player;
}

- (void)setUp {
  [super setUp];
  NSDictionary *options = @{@"amount": [NSNumber numberWithFloat:0.5]};
  _player = [OCMockObject mockForClass:Player.class];
  _playerAction = [[PlayerTurnAction alloc] initWithOptions:options];
}

- (void)tearDown {
  _playerAction = nil;
  _player = nil;
  [super tearDown];
}

- (void)testCost {
  XCTAssertEquals(_playerAction.cost, (CGFloat)10);
}

- (void)testApplyToPlayer {
  [(Player *)[[_player stub] andReturnValue:[NSNumber numberWithDouble:0]] rotation];
  [[_player expect] rotateByAngle:(M_TAU / 2) duration:0.5];
  [_playerAction applyToPlayer:_player];
}

- (void)testValidateReturnsNoErrorWhenPlayerIsAlive {
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:YES]] isAlive];
  [[[_player stub] andReturnValue:[NSNumber numberWithDouble:100]] energy];

  GameError *error;
  XCTAssert([_playerAction validateForPlayer:_player error:&error]);
  XCTAssertNil(error);
}

- (void)testValidateReturnsErrorWhenPlayerHasInsufficientEnergy {
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:YES]] isAlive];
  [[[_player stub] andReturnValue:[NSNumber numberWithDouble:0]] energy];

  GameError *error;
  XCTAssertFalse([_playerAction validateForPlayer:_player error:&error]);
  XCTAssertEquals(error.code, (NSInteger)GameErrorPlayerInsufficientEnergy);
}

- (void)testValidateReturnsErrorWhenPlayerIsDead {
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:NO]] isAlive];

  GameError *error;
  XCTAssertFalse([_playerAction validateForPlayer:_player error:&error]);
  XCTAssertEquals(error.code, (NSInteger)GameErrorPlayerNotSpawned);
}

@end
