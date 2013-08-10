//
//  AcceptanceTestCase.h
//  Flatland
//
//  Created by Josh Bassett on 30/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface AcceptanceTestCase : XCTestCase

- (void)doAsynchronousAction:(NSString *)action
       forPlayer:(NSUUID *)uuid
      parameters:(NSDictionary *)parameters
      completion:(void (^)(id JSON))block;

- (NSDictionary *)doAction:(NSString *)action
                     forPlayer:(NSUUID *)uuid
                    parameters:(NSDictionary *)parameters
                       timeout:(NSTimeInterval)timeout;

- (NSDictionary *)playerStateForPlayer:(NSUUID *)playerUUID withResponse:(NSDictionary *)response;

@end
