//
//  RouteResponse+AsyncJSON.h
//  flatland
//
//  Created by Josh Bassett on 25/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "RouteResponse.h"

@interface RouteResponse (AsyncJSON)

- (void)respondWithAsyncJSON:(NSDictionary *)json;

@end
