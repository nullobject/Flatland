//
//  AcceptanceTestCase.h
//  Flatland
//
//  Created by Josh Bassett on 30/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface AcceptanceTestCase : XCTestCase

// Performs the action for the given player.
- (void)doAction:(NSString *)action forPlayer:(NSUUID *)uuid parameters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *response))block;

- (void)performAsyncTestWithBlock:(void (^)(BOOL *stop))block timeout:(NSTimeInterval)timeout;
@end
