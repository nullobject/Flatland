//
//  PlayerSpawnActionTest.m
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

@interface PlayerSpawnActionTest : XCTestCase
@end

@implementation PlayerSpawnActionTest {
  PlayerAction *_playerAction;
  id _player;
}

- (void)setUp {
  [super setUp];
  NSDictionary *options = @{@"amount": [NSNumber numberWithFloat:0.5]};
  _player = [OCMockObject mockForClass:Player.class];
  _playerAction = [[PlayerSpawnAction alloc] initWithOptions:options];
}

- (void)tearDown {
  _playerAction = nil;
  _player = nil;
  [super tearDown];
}

- (void)testCost {
  XCTAssertEquals(_playerAction.cost, (CGFloat)0);
}

- (void)testApplyToPlayer {
  [[_player expect] spawn];
  [_playerAction applyToPlayer:_player];
}

- (void)testValidateReturnsNoErrorWhenPlayerIsDead {
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:NO]] isAlive];

  GameError *error;
  XCTAssert([_playerAction validateForPlayer:_player error:&error]);
  XCTAssertNil(error);
}

- (void)testValidateReturnsErrorWhenPlayerIsAlive {
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:YES]] isAlive];

  GameError *error;
  XCTAssertFalse([_playerAction validateForPlayer:_player error:&error]);
  XCTAssertNotNil(error);
}

@end
