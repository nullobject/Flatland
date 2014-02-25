//
//  AcceptanceTestCase.h
//  Flatland
//
//  Created by Josh Bassett on 30/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

extern NSTimeInterval const kTimeout;

extern NSString * const kRootURL;

@interface AcceptanceTestCase : XCTestCase

- (void)runAsynchronousAction:(NSString *)action
                    forPlayer:(NSUUID *)uuid
                   parameters:(NSDictionary *)parameters
                   completion:(void (^)(id JSON))block;

- (NSDictionary *)runAction:(NSString *)action
                  forPlayer:(NSUUID *)uuid
                 parameters:(NSDictionary *)parameters
                    timeout:(NSTimeInterval)timeout;

- (NSDictionary *)playerStateForPlayer:(NSUUID *)playerUUID withResponse:(NSDictionary *)response;

@end
