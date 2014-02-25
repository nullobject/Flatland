//
//  AttackPlayerTests.m
//  Flatland
//
//  Created by Josh Bassett on 30/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AcceptanceTestCase.h"
#import "Core.h"

@interface PlayerAttackTests : AcceptanceTestCase
@end

@implementation PlayerAttackTests {
  NSUUID *_playerUUID;
}

- (void)setUp {
  [super setUp];
  _playerUUID = [NSUUID UUID];
}

- (void)tearDown {
  [self runAction:@"suicide" forPlayer:_playerUUID parameters:nil timeout:5];
  [super tearDown];
}

- (void)testAttackPlayer {
  [self runAction:@"spawn" forPlayer:_playerUUID parameters:nil timeout:5];

  NSDictionary *response = [self runAction:@"attack" forPlayer:_playerUUID parameters:@{@"amount": @1} timeout:3];
  NSDictionary *playerState = [self playerStateForPlayer:_playerUUID withResponse:response];

  expect([playerState objectForKey:@"state"]).to.equal(@"attacking");
  expect([playerState objectForKey:@"energy"]).to.equal(80);
}

- (void)testKillPlayer {
  NSUUID *enemyUUID = [NSUUID UUID];

  [self player:_playerUUID faceEnemy:enemyUUID];
  [self player:_playerUUID killEnemy:enemyUUID];
}

- (void)testAttackPlayerWhenPlayerIsDead {
  NSDictionary *response = [self runAction:@"attack" forPlayer:_playerUUID parameters:@{@"amount": @1} timeout:3];

  expect([response objectForKey:@"code"]).to.equal(4);
  expect([response objectForKey:@"error"]).to.equal(@"Player has not spawned");
}

- (void)testAttackPlayerWhenPlayerHasInsufficientEnergy {
  [self runAction:@"spawn" forPlayer:_playerUUID parameters:nil timeout:5];

  [self runAction:@"attack" forPlayer:_playerUUID parameters:@{@"amount": @1} timeout:3];
  [self runAction:@"attack" forPlayer:_playerUUID parameters:@{@"amount": @1} timeout:3];
  [self runAction:@"attack" forPlayer:_playerUUID parameters:@{@"amount": @1} timeout:3];
  [self runAction:@"attack" forPlayer:_playerUUID parameters:@{@"amount": @1} timeout:3];
  [self runAction:@"attack" forPlayer:_playerUUID parameters:@{@"amount": @1} timeout:3];

  NSDictionary *response = [self runAction:@"attack" forPlayer:_playerUUID parameters:@{@"amount": @1} timeout:3];

  expect([response objectForKey:@"code"]).to.equal(6);
  expect([response objectForKey:@"error"]).to.equal(@"Player has insufficient energy");
}

#pragma mark - Helpers

- (void)player:(NSUUID *)playerUUID faceEnemy:(NSUUID *)enemyUUID {
  NSDictionary *response;
  CGPoint a, b;

  response = [self runAction:@"spawn" forPlayer:playerUUID parameters:nil timeout:5];
  NSDictionary *playerState = [self playerStateForPlayer:playerUUID withResponse:response];

  response = [self runAction:@"spawn" forPlayer:enemyUUID parameters:nil timeout:5];
  NSDictionary *enemyState = [self playerStateForPlayer:enemyUUID withResponse:response];

  PointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)[enemyState objectForKey:@"position"], &a);
  PointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)[playerState objectForKey:@"position"], &b);

  CGFloat angle = POLAR_ADJUST(AngleBetweenPoints(a, b));
  CGFloat amount = NORMALIZE_ANGLE(angle);

  [self runAction:@"turn" forPlayer:playerUUID parameters:@{@"amount": [NSNumber numberWithFloat:amount]} timeout:3];
}

- (void)player:(NSUUID *)playerUUID killEnemy:(NSUUID *)enemyUUID {
  NSDictionary *response;
  BOOL alive = YES;

  while (alive) {
    response = [self runAction:@"attack" forPlayer:playerUUID parameters:@{@"amount": @1} timeout:3];

    if ([response objectForKey:@"error"]) {
      [self runAction:@"rest" forPlayer:playerUUID parameters:@{@"amount": @1} timeout:3];
    } else {
      NSDictionary *enemyState = [self playerStateForPlayer:enemyUUID withResponse:response];
      alive = [[enemyState objectForKey:@"health"] floatValue] > 0;
    }
  }

  NSDictionary *playerState = [self playerStateForPlayer:playerUUID withResponse:response];
  expect([[playerState objectForKey:@"kills"] integerValue]).to.equal(1);

  NSDictionary *enemyState = [self playerStateForPlayer:enemyUUID withResponse:response];
  expect([[enemyState objectForKey:@"deaths"] integerValue]).to.equal(1);
}

@end
