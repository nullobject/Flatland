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

- (void)setData:(NSData *)data;

@end
