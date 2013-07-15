//
//  RouteResponse+JSON.h
//  Flatland
//
//  Created by Josh Bassett on 25/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "RouteResponse.h"
#import "Serializable.h"

@interface RouteResponse (JSON)

- (void)respondWithJSON:(NSObject <Serializable> *)object;
- (void)beginAsyncJSONResponse;
- (void)endAsyncJSONResponse:(NSObject <Serializable> *)object;

@end
