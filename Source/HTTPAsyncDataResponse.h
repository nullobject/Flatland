//
//  HTTPAsyncDataResponse.h
//  flatland
//
//  Created by Josh Bassett on 25/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HTTPDataResponse.h"

@interface HTTPAsyncDataResponse : HTTPDataResponse

@property (nonatomic, readonly) BOOL closed;

- (void)setData:(NSData *)data;

@end
