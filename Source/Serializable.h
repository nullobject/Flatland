//
//  Serializable.h
//  Flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Serializable <NSObject>

// Returns the object represented as a JSON object (nested dictionary).
- (NSDictionary *)asJSON;

@end
