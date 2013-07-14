//
//  NSDictionary+Point.m
//  Flatland
//
//  Created by Josh Bassett on 15/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "NSDictionary+Point.h"

@implementation NSDictionary (Point)

+ (NSDictionary *)dictionaryWithPoint:(CGPoint)point {
  return @{@"x": [NSNumber numberWithFloat:point.x],
           @"y": [NSNumber numberWithFloat:point.y]};
}

@end
