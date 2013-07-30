//
//  AcceptanceTestCase.h
//  Flatland
//
//  Created by Josh Bassett on 30/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface AcceptanceTestCase : XCTestCase

// Peforms the action for the given player.
- (id)doAction:(NSString *)action forPlayer:(NSUUID *)uuid;
- (id)doAction:(NSString *)action forPlayer:(NSUUID *)uuid parameters:(NSDictionary *)parameters;

// Waits for the duration taken to execute the given action.
- (void)waitForAction:(NSString *)action;

@end
