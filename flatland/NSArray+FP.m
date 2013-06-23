//
//  NSArray+FP.m
//  flatland
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "NSArray+FP.h"

@implementation NSArray (FP)

- (NSArray *)map:(MapBlock)block {
  NSMutableArray *resultArray = [[NSMutableArray alloc] init];
  for (id object in self) {
    [resultArray addObject:block(object)];
  }
  return resultArray;
}

- (id)head {
  return [self objectAtIndex:0];
}

- (NSArray *)tail {
  NSRange tailRange;
  tailRange.location = 1;
  tailRange.length = [self count] - 1;
  return [self subarrayWithRange:tailRange];
}

@end
