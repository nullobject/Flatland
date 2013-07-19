//
//  PlayerIdleActionTests.m
//  Flatland
//
//  Created by Josh Bassett on 19/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "GameError.h"
#import "OCMock.h"
#import "Player.h"
#import "PlayerIdleAction.h"

@interface PlayerIdleActionTests : XCTestCase
@end

@implementation PlayerIdleActionTests {
  PlayerAction *_playerAction;
  id _player;
}

- (void)setUp {
  [super setUp];
  _player = [OCMockObject mockForClass:Player.class];
  _playerAction = [[PlayerIdleAction alloc] initWithOptions:@{}];
}

- (void)tearDown {
  _playerAction = nil;
  _player = nil;
  [super tearDown];
}

- (void)testCost {
  XCTAssertEquals(_playerAction.cost, (CGFloat)-10);
}

- (void)testApplyToPlayer {
  [[_player expect] idle];
  [_playerAction applyToPlayer:_player];
}

- (void)testValidateReturnsNoErrorWhenPlayerIsAlive {
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:YES]] isAlive];
  [[[_player stub] andReturnValue:[NSNumber numberWithDouble:100]] energy];

  GameError *error;
  XCTAssert([_playerAction validateForPlayer:_player error:&error]);
  XCTAssertNil(error);
}

- (void)testValidateReturnsErrorWhenPlayerIsDead {
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:NO]] isAlive];

  GameError *error;
  XCTAssertFalse([_playerAction validateForPlayer:_player error:&error]);
  XCTAssertEquals(error.code, (NSInteger)GameErrorPlayerNotSpawned);
}

@end
