//
//  EntityTests.m
//  flatlandTests
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Entity.h"

@interface EntityTests : XCTestCase
@end

@implementation EntityTests {
  Entity *_entity;
}

- (void)setUp {
  [super setUp];
  _entity = [[Entity alloc] init];
}

- (void)tearDown {
  _entity = nil;
  [super tearDown];
}

- (void)testIdleSetsState {
  [_entity idle];
  XCTAssertEquals(_entity.state, EntityStateIdle);
}

- (void)testIdleRestoresEnergy {
  _entity.energy = 90;
  [_entity idle];
  XCTAssertEquals(_entity.energy, (NSInteger)100);
  [_entity idle];
  XCTAssertEquals(_entity.energy, (NSInteger)100);
}

@end
