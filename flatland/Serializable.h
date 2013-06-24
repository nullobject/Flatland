//
//  Serializable.h
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Serializable <NSObject>

// Returns the object represented as a nested dictionary.
- (NSDictionary *)asJSON;

@end
