//
//  PlayerMoveActionTest.m
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
  XCTAssertEquals(_playerAction.cost, (CGFloat)10);
}

- (void)testApplyToPlayer {
  [(Player *)[[_player stub] andReturnValue:[NSNumber numberWithDouble:0]] rotation];
  [[_player expect] moveByX:0 y:50 duration:0.25];
  [_playerAction applyToPlayer:_player];
}

@end
