//
//  WorldTests.m
//  Flatland
//
//  Created by Josh Bassett on 20/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <XCTest/XCTest.h>

#import "GameError.h"
#import "OCMock.h"
#import "Player.h"
#import "PlayerAction.h"
#import "PlayerNode.h"
#import "PlayerOverlayNode.h"
#import "World.h"

@interface World (Tests)

@property (nonatomic) WorldNode *worldNode;

@end

@interface WorldTests : XCTestCase
@end

@implementation WorldTests {
  World *_world;
}

- (void)setUp {
  [super setUp];
  _world = [[World alloc] init];
}

- (void)tearDown {
  _world = nil;
  [super tearDown];
}

- (void)testSetsPlayers {
  expect(_world.players).toNot.beNil();
}

- (void)testSetsWorldNode {
  expect(_world.worldNode).toNot.beNil();
}

#pragma mark - Tick

- (void)testTickIncrementsAge {
  expect(_world.age).to.equal(0);
  [_world tick];
  expect(_world.age).to.equal(1);
}

- (void)testTickTicksPlayers {
  id player = [OCMockObject mockForClass:Player.class];

  NSUUID *uuid = [NSUUID UUID];
  [(NSMutableDictionary *)_world.players setObject:player forKey:uuid];

  [[player expect] tick];
  [_world tick];
  [player verify];
}

#pragma mark - EnqueueAction

- (void)testEnqueueActionEnqueuesActionForPlayer {
  id player = [OCMockObject mockForClass:Player.class];
  id action = [OCMockObject mockForClass:PlayerAction.class];

  NSUUID *uuid = [NSUUID UUID];
  [(NSMutableDictionary *)_world.players setObject:player forKey:uuid];

  void (^block)(void) = ^{};
  [[player expect] applyAction:action completion:block error:nil];
  [_world enqueueAction:action forPlayer:uuid completion:block error:nil];
  [player verify];
}

#pragma mark - Callbacks

- (void)testPlayerDidSpawn {
  id worldNode         = [OCMockObject mockForClass:WorldNode.class];
  id player            = [OCMockObject mockForClass:Player.class];
  id playerNode        = [OCMockObject niceMockForClass:PlayerNode.class];
  id playerOverlayNode = [OCMockObject niceMockForClass:PlayerOverlayNode.class];

  _world.worldNode = worldNode;
  
  [[[player stub] andReturn:playerNode] playerNode];
  [[[player stub] andReturn:playerOverlayNode] playerOverlayNode];

  [[worldNode expect] addChild:playerNode];
  [[worldNode expect] addChild:playerOverlayNode];
  [_world playerDidSpawn:player];
  [worldNode verify];
}

- (void)testPlayerDidDie {
  id player            = [OCMockObject mockForClass:Player.class];
  id playerNode        = [OCMockObject niceMockForClass:PlayerNode.class];
  id playerOverlayNode = [OCMockObject niceMockForClass:PlayerOverlayNode.class];

  [[[player stub] andReturn:playerNode] playerNode];
  [[[player stub] andReturn:playerOverlayNode] playerOverlayNode];

  [[playerNode expect] removeFromParent];
  [[playerOverlayNode expect] removeFromParent];
  [_world playerDidDie:player];
  [playerNode verify];
}

- (void)testPlayerDidShootBullet {
  id worldNode  = [OCMockObject mockForClass:SKNode.class];
  id player     = [OCMockObject mockForClass:Player.class];
  id playerNode = [OCMockObject mockForClass:SKNode.class];
  id bulletNode = [OCMockObject niceMockForClass:SKNode.class];

  _world.worldNode = worldNode;
  [[[player stub] andReturn:playerNode] playerNode];

  [[worldNode expect] addChild:bulletNode];
  [_world player:player didShootBullet:bulletNode];
  [worldNode verify];
}

#pragma mark - Serializable

- (void)testAsJSON {
  id expected = @{@"age":     @0,
                  @"players": @[]};

  expect([_world asJSON]).to.equal(expected);
}

@end
